#!/bin/bash

mkdir -p exits logs

EXIT_DIR="exits"
LOG_FILE="logs/performance_scalability.log"
RESOURCE_LOG="logs/resource_usage.log"

rm -f $LOG_FILE

echo "=== Verificando Rendimiento y Escalabilidad ==="

measure_performance() {
  local args="$1"
  local description="$2"
  local test_exit_file="$EXIT_DIR/test_performance_${description// /_}.txt"

  echo "Ejecutando prueba: $description"
  
  (time (timeout 20 ./philo $args > "$test_exit_file" 2>&1)) &> "$RESOURCE_LOG"

  local exit_code=$?

  if [[ "$args" == "0 "* ]]; then
    if [ -s "$test_exit_file" ]; then
      echo "[FAIL] $description - El archivo de salida no debe tener contenido cuando hay 0 filósofos" >> $LOG_FILE
    else
      echo "[PASS] $description - El archivo de salida está vacío como se esperaba" >> $LOG_FILE
    fi
  else
    if [ -s "$test_exit_file" ]; then
      echo "[PASS] $description - Resultado esperado: salida generada correctamente" >> $LOG_FILE
    else
      echo "[FAIL] $description - El archivo de salida está vacío cuando no debería" >> $LOG_FILE
    fi
  fi

  echo "Uso de recursos para $description:" >> $LOG_FILE
  grep "real" "$RESOURCE_LOG" >> $LOG_FILE
  grep "user" "$RESOURCE_LOG" >> $LOG_FILE
  grep "sys" "$RESOURCE_LOG" >> $LOG_FILE
  grep "max" "$RESOURCE_LOG" >> $LOG_FILE
}

# 1. Prueba de rendimiento con 100 filósofos
measure_performance "100 800 200 200" "100 filósofos"

# 2. Prueba de rendimiento con 500 filósofos
measure_performance "500 800 200 200" "500 filósofos"

# 3. Prueba de rendimiento con 1000 filósofos
measure_performance "1000 800 200 200" "1000 filósofos"

# 4. Medir el uso de recursos para una simulación con un número alto de filósofos
measure_performance "50 1000 1000 1000" "50 filósofos (con tiempos más largos)"

# 5. Escalabilidad - aumentar el número de filósofos gradualmente
for philosophers in 10 50 100 200 500 1000; do
  measure_performance "$philosophers 800 200 200" "${philosophers} filósofos"
done

# 6. Prueba con 0 filósofos (debería estar vacío)
measure_performance "0 800 200 200" "0 filósofos"

echo "Pruebas completadas. Ver resultados en $LOG_FILE y salidas en $EXIT_DIR."

