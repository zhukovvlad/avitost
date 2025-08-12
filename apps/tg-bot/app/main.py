import asyncio
import os

import httpx
from aiogram import Bot, Dispatcher, F
from aiogram.types import Message
from dotenv import load_dotenv

load_dotenv()

BOT_TOKEN = os.getenv("TG_BOT_TOKEN", "")
YANDEX_TOKEN = os.getenv("YANDEX_TOKEN")  # OAuth токен Я.Диска

# Проверяем токен перед созданием бота
if not BOT_TOKEN:
    print("❌ Ошибка: TG_BOT_TOKEN не настроен в .env файле")
    print("Установите токен в .env файле и перезапустите бота")
    exit(1)

bot = Bot(BOT_TOKEN)
dp = Dispatcher()


@dp.message(F.text & F.text.startswith("/start"))
async def start_command(m: Message):
    await m.reply(
        "👋 Привет! Отправь мне фото, и я сохраню его на Яндекс.Диск.\n"
        "📸 Просто загрузи любое изображение!"
    )


@dp.message(F.photo)
async def save_photo(m: Message):
    if not m.photo:
        await m.reply("❌ Ошибка: фото не найдено")
        return

    if not YANDEX_TOKEN:
        await m.reply("❌ Ошибка: YANDEX_TOKEN не настроен в .env файле")
        return

    try:
        file = await bot.get_file(m.photo[-1].file_id)
        file_url = f"https://api.telegram.org/file/bot{BOT_TOKEN}/{file.file_path}"

        async with httpx.AsyncClient(timeout=60) as c:
            # 1) Получаем upload URL
            resp = await c.get(
                "https://cloud-api.yandex.net/v1/disk/resources/upload",
                params={"path": f"app/{file.file_unique_id}.jpg", "overwrite": "true"},
                headers={"Authorization": f"OAuth {YANDEX_TOKEN}"},
            )
            resp.raise_for_status()
            href = resp.json()["href"]

            # 2) Загружаем файл
            tg = await c.get(file_url)
            up = await c.put(href, content=tg.content)
            up.raise_for_status()

        await m.reply("Фото сохранено на Яндекс.Диск ✅")

    except httpx.HTTPStatusError as e:
        if e.response.status_code == 401:
            await m.reply("❌ Ошибка авторизации: проверьте YANDEX_TOKEN")
        elif e.response.status_code == 403:
            await m.reply("❌ Нет доступа к Яндекс.Диску")
        else:
            await m.reply(f"❌ Ошибка HTTP: {e.response.status_code}")
    except Exception as e:
        await m.reply(f"❌ Ошибка: {str(e)}")
        print(f"Ошибка при сохранении фото: {e}")


async def main():
    if not YANDEX_TOKEN:
        print("⚠️ Предупреждение: YANDEX_TOKEN не настроен в .env файле")
        print("Бот будет работать, но загрузка на Яндекс.Диск будет недоступна")

    print("🤖 Запускаем Telegram бота...")
    await dp.start_polling(bot)


if __name__ == "__main__":
    asyncio.run(main())
