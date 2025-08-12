import { Button } from "@/components/ui/button";

export default function App() {
  const handleLogin = () => {
    // Используем переменную окружения для API URL
    const apiBase =
      import.meta.env.VITE_API_BASE || "http://localhost:8000/api";
    window.location.href = `${apiBase}/login`;
  };

  const handleHealthCheck = async () => {
    try {
      const apiBase =
        import.meta.env.VITE_API_BASE || "http://localhost:8000/api";
      const response = await fetch(`${apiBase}/health`);
      const data = await response.json();
      alert(`Backend статус: ${data.status}`);
    } catch (error) {
      console.error("Backend connection error:", error);
      alert(
        `Ошибка соединения с backend: ${
          error instanceof Error ? error.message : "Неизвестная ошибка"
        }`
      );
    }
  };

  return (
    <div className="flex h-screen items-center justify-center flex-col gap-4">
      <h1 className="text-4xl font-bold text-center mb-8">AviTost</h1>
      <div className="flex gap-4">
        <Button onClick={handleLogin}>Войти через Яндекс</Button>
        <Button variant="outline" onClick={handleHealthCheck}>
          Проверить Backend
        </Button>
      </div>
    </div>
  );
}
