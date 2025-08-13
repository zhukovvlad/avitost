# Docker Guide

## 🐳 Quick Start

```bash
cd infra/compose
docker-compose up -d
```

## 📋 Services Overview

| Service    | Local Port | Container Port | Status Endpoint                         |
| ---------- | ---------- | -------------- | --------------------------------------- |
| FastAPI    | 8000       | 8000           | http://localhost:8000/                  |
| Go API     | 8080       | 8001           | http://localhost:8080/health            |
| PostgreSQL | 5432       | 5432           | `pg_isready -U app`                     |
| Redis      | 6379       | 6379           | `redis-cli ping`                        |
| MinIO      | 9000/9001  | 9000/9001      | http://localhost:9000/minio/health/live |

## 🔧 Docker Commands

### Basic Operations

```bash
# Start all services
docker-compose up -d

# View running containers
docker-compose ps

# View logs
docker-compose logs [service-name]

# Stop all services
docker-compose down

# Restart specific service
docker-compose restart [service-name]
```

### Development Workflow

```bash
# Rebuild and restart after code changes
docker-compose build [service-name]
docker-compose up -d [service-name]

# Force rebuild (no cache)
docker-compose build --no-cache [service-name]

# View real-time logs
docker-compose logs -f [service-name]
```

### Debugging

```bash
# Execute commands in running container
docker-compose exec fastapi /bin/bash
docker-compose exec goapi /bin/sh
docker-compose exec postgres psql -U app

# Check container health
docker inspect avitost_fastapi --format='{{.State.Health.Status}}'
```

## 🏗 Architecture

```
┌─────────────────┐    ┌──────────────────┐
│   FastAPI       │    │    Go API        │
│   (Python)      │    │    (Gin)         │
│   Port: 8000    │    │    Port: 8080    │
└─────────┬───────┘    └──────────┬───────┘
          │                       │
          └───────┬───────────────┘
                  │
    ┌─────────────▼──────────────┐
    │       PostgreSQL           │
    │       Port: 5432           │
    └─────────────┬──────────────┘
                  │
    ┌─────────────▼──────────────┐
    │        Redis               │
    │       Port: 6379           │
    └────────────────────────────┘

    ┌────────────────────────────┐
    │        MinIO               │
    │    Ports: 9000/9001        │
    └────────────────────────────┘
```

## 🔒 Security Features

### Container Security

- Non-root users in all application containers
- Minimal base images (alpine, slim)
- Multi-stage builds to reduce attack surface
- Health checks with proper timeouts

### Network Security

- Isolated Docker network (`avitost_network`)
- Only necessary ports exposed to host
- Service-to-service communication via container names

### Data Security

- Persistent volumes for database data
- Environment-based configuration
- Secrets management via .env files

## 📊 Health Monitoring

All services include health checks:

```bash
# Check all service health
docker-compose ps

# Individual health checks
curl http://localhost:8000/        # FastAPI
curl http://localhost:8080/health  # Go API
docker-compose exec postgres pg_isready -U app
docker-compose exec redis redis-cli ping
curl http://localhost:9000/minio/health/live  # MinIO
```

## 🚀 Production Deployment

### Environment Variables

Create production `.env`:

```bash
# Use strong passwords
POSTGRES_PASSWORD=your_strong_password
MINIO_ROOT_PASSWORD=your_strong_minio_password

# Use production URLs
OAUTH_REDIRECT_URI=https://yourdomain.com/oauth/callback
VITE_API_BASE=https://yourdomain.com/api

# Disable debug mode
GIN_MODE=release
```

### Production Compose

```bash
# Use production override
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### Resource Limits

Add to docker-compose.yml:

```yaml
services:
  fastapi:
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: "0.5"
```

## 🔧 Troubleshooting

### Common Issues

**Port Already in Use**

```bash
# Find process using port
sudo lsof -i :8000

# Stop all compose services
docker-compose down
```

**Container Won't Start**

```bash
# Check logs
docker-compose logs [service-name]

# Check health status
docker-compose ps

# Rebuild container
docker-compose build --no-cache [service-name]
```

**Database Connection Issues**

```bash
# Check postgres is ready
docker-compose exec postgres pg_isready -U app

# Connect to database
docker-compose exec postgres psql -U app -d app
```

**Permission Denied**

```bash
# Fix file permissions
sudo chown -R $USER:$USER .

# Or run with sudo (not recommended)
sudo docker-compose up -d
```

### Performance Tuning

**PostgreSQL**

```sql
-- Inside postgres container
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET max_connections = '200';
SELECT pg_reload_conf();
```

**Resource Monitoring**

```bash
# Container resource usage
docker stats

# Specific container stats
docker stats avitost_postgres
```

## 📝 Logs Management

### Log Locations

```bash
# Application logs
docker-compose logs fastapi
docker-compose logs goapi

# System logs
docker-compose logs postgres
docker-compose logs redis
```

### Log Rotation

Add to docker-compose.yml:

```yaml
services:
  fastapi:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```
