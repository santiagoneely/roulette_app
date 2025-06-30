# Roulette Casino Simulator

Simulación de una mesa de ruleta con jugadores dinámicos y apuestas condicionadas por el clima de Santiago, Chile.

A Cada jugador que creas, se le puede asignar:
Monto de partida, que usará para sus apuestas. Al final de cada día se le suman $10.000
Perfil: Normal o IA.
   Normal apostará un numero random entre los porcentajes establecidos, dependiendo del clima.
   IA hará una consulta a OpenIA que entregará un monto a apostar.

   Cada 3 minutos, un worker ejecuta una ronda de juego, pero también se pueden ejecutar rondas manuales con un botón.

   El monto de la apuesta depende del clima en los próximos 7 días en Santiago de Chile. Si habrá al menos un día con temperaturas pronosticadas sobre los 23ºC, los jugadores apuestan más conservador, entre 3 y 7% de su caja restante. Si está frío, apuestan entre 8 y 15%.

   

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

   Crea un archivo `.env` en la raíz del proyecto.
   Puedes copiar el archivo .env.example y poner los valores de las API_KEY
   O usar el archivo .env.example
   ```env
   WEATHER_API_KEY=tu_api_key_de_weatherapi
   OPENAI_API_KEY=tu_api_key_de_openai
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
