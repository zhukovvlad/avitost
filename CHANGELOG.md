# Changelog

## [Unreleased] - 2025-08-13

### Added

- Complete Docker Compose configuration with all services
- Health checks for all containers
- Multi-stage Docker builds for optimal image sizes
- Production-ready PostgreSQL 16 setup
- MinIO S3-compatible storage service
- Redis caching layer

### Changed

- Updated Go to version 1.23 (from 1.21) for security fixes
- Fixed port mappings: Go API now correctly maps 8080->8001
- Updated Python dependencies (added httpx)
- Improved Dockerfile security with non-root users
- Enhanced documentation with Docker deployment instructions

### Fixed

- Go API healthcheck endpoint configuration
- FastAPI missing httpx dependency
- Port conflicts between services
- Container restart policies and dependencies

### Security

- Upgraded Go base image to fix 1 critical and 5 high vulnerabilities
- Added security-focused Docker configurations
- Implemented proper user permissions in containers

### Technical Details

- PostgreSQL 16 with optimized healthchecks
- Redis 7-alpine for smaller footprint
- Go 1.23-alpine builder with security patches
- Python 3.12-slim with curl for healthchecks
- Proper service dependencies with condition: service_healthy
- Named Docker network for service isolation
