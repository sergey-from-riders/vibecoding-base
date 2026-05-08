# infra/nginx

Nginx reverse proxy templates for server deployment.

## Ports model
- Frontend listens on `127.0.0.1:18030`
- Backend listens on `127.0.0.1:18031`
- Nginx listens on `80/443` and proxies requests

## Install steps on server
1. Copy `ai-app.conf.example` to `/etc/nginx/sites-available/ai-app.conf`
2. Replace `server_name` with real domain
3. Enable site:
   - `ln -s /etc/nginx/sites-available/ai-app.conf /etc/nginx/sites-enabled/ai-app.conf`
4. Validate and reload:
   - `nginx -t && systemctl reload nginx`

## TLS
Use certbot or existing ACME flow for `app.example.test`.
