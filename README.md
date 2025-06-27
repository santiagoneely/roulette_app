# Roulette Casino Simulator

Simulación de una mesa de ruleta con jugadores dinámicos y apuestas condicionadas por el clima de Santiago, Chile.

## Requisitos

- Ruby 3.4.4 (recomendado usar rbenv o RVM)
- Rails 8.x
- Redis (para Sidekiq)
- PostgreSQL (para producción) o SQLite (para desarrollo)
- Node.js y Yarn (para assets, si usas Rails 7+)

## Instalación y ejecución en local

1. **Clona el repositorio:**
   ```sh
   git clone <URL_DEL_REPO>
   cd roulette_app
   ```

2. **Instala las dependencias:**
   ```sh
   bundle install
   ```

3. **Configura las variables de entorno:**
   Crea un archivo `.env` en la raíz del proyecto con:
   ```env
   WEATHER_API_KEY=tu_api_key_de_weatherapi
   OPENAI_API_KEY=tu_api_key_de_openai
   REDIS_URL=redis://localhost:6379/0
   ```

4. **Configura la base de datos:**
   - Por defecto, en desarrollo usa SQLite. Si prefieres PostgreSQL, edita `config/database.yml`.
   - Crea y migra la base de datos:
     ```sh
     rails db:create
     rails db:migrate
     rails db:seed # Opcional, para jugadores de prueba
     ```

5. **Arranca Redis (en otra terminal):**
   ```sh
   redis-server
   ```

6. **Arranca Sidekiq (en otra terminal):**
   ```sh
   bundle exec sidekiq -C config/sidekiq.yml
   ```

7. **Arranca el servidor Rails:**
   ```sh
   rails server
   ```

8. **Accede a la app:**
   - [http://localhost:3000](http://localhost:3000)
   - La vista principal muestra el historial de rondas y apuestas.

## Notas
- Las rondas se juegan automáticamente cada 3 minutos.
- Puedes ejecutar una ronda manualmente desde la vista principal.
- Al final del día, todos los jugadores reciben $10.000 automáticamente.
- Algunos jugadores pueden usar IA (OpenAI) para decidir sus apuestas.

---

## Deploy en Render

1. **Sube tu proyecto a GitHub.**

2. **Crea una cuenta en [Render](https://render.com/).**

3. **Crea un nuevo Web Service:**
   - Haz clic en "New +" > "Web Service".
   - Conecta tu cuenta de GitHub y selecciona el repositorio.
   - Elige Ruby como entorno.
   - Usa la rama principal (`main` o `master`).
   - Build Command:
     ```sh
     bundle install && bundle exec rails db:migrate
     ```
   - Start Command:
     ```sh
     bundle exec rails server
     ```

4. **Crea un Worker para Sidekiq:**
   - "New +" > "Background Worker".
   - Usa el mismo repo y rama.
   - Start Command:
     ```sh
     bundle exec sidekiq -C config/sidekiq.yml
     ```

5. **Agrega un servicio Redis:**
   - "New +" > "Redis".
   - Render te dará una URL, ponla como variable de entorno `REDIS_URL` en ambos servicios (web y worker).

6. **Agrega una base de datos PostgreSQL:**
   - "New +" > "PostgreSQL".
   - Render te dará una URL, ponla como variable de entorno `DATABASE_URL`.

7. **Agrega las variables de entorno necesarias:**
   - `RAILS_ENV=production`
   - `REDIS_URL=...` (la que te da Render)
   - `DATABASE_URL=...` (la que te da Render)
   - `WEATHER_API_KEY=...`
   - `OPENAI_API_KEY=...`

8. **Despliega y prueba:**
   - Render hará el build y deploy automáticamente.
   - Cuando termine, tendrás una URL pública para tu app.

---

¿Listo! Ahora puedes compartir el link de Render para que los evaluadores accedan a la app en producción.
