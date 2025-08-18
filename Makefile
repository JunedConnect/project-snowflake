.PHONY: airflow-start airflow-stop airflow-remove airflow-logs airflow-restart-soft airflow-restart-hard

# Start Airflow container
airflow-start:
	@echo "Starting Airflow containers..."
	docker compose -f ./docker-compose.yml up -d
	@echo "Airflow containers started successfully!"
	@echo "Use the following command to see logs: make airflow-logs"

# Stop Airflow container (preserves volumes)
airflow-stop:
	@echo "Stopping Airflow containers..."
	docker compose -f ./docker-compose.yml down
	@echo "Airflow containers stopped."

# Stop and remove Airflow container, including volumes and images
airflow-remove:
	@echo "Removing Airflow containers, volumes, and images..."
	docker compose -f ./docker-compose.yml down --volumes --rmi all
	@echo "Removal complete."

# Show live logs for Airflow
airflow-logs:
	@echo "Tailing Airflow logs... Press Ctrl+C to exit."
	docker compose -f ./docker-compose.yml logs -f

# Soft restart (keep volumes and images)
airflow-restart-soft:
	@echo "Performing soft restart..."
	docker compose -f ./docker-compose.yml down
	docker compose -f ./docker-compose.yml up -d
	@echo "Soft restart complete. Follow logs with: make airflow-logs"

# Hard restart (remove everything and start fresh)
airflow-restart-hard:
	@echo "Performing hard restart..."
	docker compose -f ./docker-compose.yml down --volumes --rmi all
	docker compose -f ./docker-compose.yml up -d
	@echo "Hard restart complete. Follow logs with: make airflow-logs"