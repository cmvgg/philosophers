#!/bin/bash

mkdir -p exits logs valgrind_reports

EXIT_DIR="exits"
LOG_FILE="logs/concurrency_deep.log"
VALGRIND_DIR="valgrind_reports"

rm -f $LOG_FILE
rm -rf $VALGRIND_DIR/*

echo "=== Verificando Concurrencia y Casos Extremos ===" >> $LOG_FILE

test_case() {
  local args="$1"
  local description="$2"
  local test_exit_file="$EXIT_DIR/test_concurrency_${description// /_}.txt"
  local valgrind_file="$VALGRIND_DIR/${description// /_}_valgrind.txt"

  timeout 20 ./philo $args > "$test_exit_file" 2>&1
  local exit_code=$?

  if grep -q "Error" "$test_exit_file"; then
    echo "[FAIL] $description - Error detectado en salida estándar" >> $LOG_FILE
  elif grep -q "died" "$test_exit_file"; then
    echo "[PASS] $description - Muerte detectada correctamente" >> $LOG_FILE
  elif grep -q "is eating" "$test_exit_file"; then
    echo "[PASS] $description - Comportamiento esperado, los filósofos comen" >> $LOG_FILE
  else
    echo "[FAIL] $description - Comportamiento inesperado" >> $LOG_FILE
  fi

 timeout 30  valgrind --tool=helgrind --log-file="$valgrind_file" ./philo $args > /dev/null
  if grep -q "0 errors from 0 contexts" "$valgrind_file"; then
    echo "[PASS] $description - Sin condiciones de carrera (Hellgrind)" >> $LOG_FILE
  else
    echo "[FAIL] $description - Condiciones de carrera detectadas (Hellgrind)" >> $LOG_FILE
  fi

  timeout 25  valgrind --leak-check=full --show-leak-kinds=all --log-file="$valgrind_file" ./philo $args > /dev/null
  if grep -q "All heap blocks were freed" "$valgrind_file"; then
    echo "[PASS] $description - Sin fugas de memoria detectadas (Memcheck)" >> $LOG_FILE
  else
    echo "[FAIL] $description - Fugas de memoria detectadas (Memcheck)" >> $LOG_FILE
  fi
}

test_case3() {
  local args="$1"
  local description="$2"
  local test_exit_file="$EXIT_DIR/test_concurrency_${description// /_}.txt"
  local valgrind_file="$VALGRIND_DIR/${description// /_}_valgrind.txt"

  timeout 20 ./philo $args > "$test_exit_file" 2>&1
  local exit_code=$?

  if grep -q "Error" "$test_exit_file"; then
    echo "[PASS] $description - Error detectado en salida estándar" >> $LOG_FILE
  elif grep -q "died" "$test_exit_file"; then
    echo "[FAIL] $description - Muerte detectada correctamente" >> $LOG_FILE
  elif grep -q "is eating" "$test_exit_file"; then
    echo "[FAIL] $description - Comportamiento esperado, los filósofos comen" >> $LOG_FILE
  else
    echo "[FAIL] $description - Comportamiento inesperado" >> $LOG_FILE
  fi
}

test_case4() {
  local args="$1"
  local description="$2"
  local test_exit_file="$EXIT_DIR/test_concurrency_${description// /_}.txt"
  local valgrind_file="$VALGRIND_DIR/${description// /_}_valgrind.txt"

  timeout 20 ./philo $args > "$test_exit_file" 2>&1
  local exit_code=$?

  if grep -q "Error" "$test_exit_file"; then
    echo "[FAIL] $description - Error detectado en salida estándar" >> $LOG_FILE
  elif grep -q "died" "$test_exit_file"; then
    echo "[PASS] $description - Muerte detectada correctamente" >> $LOG_FILE
  elif grep -q "is eating" "$test_exit_file"; then
    echo "[PASS] $description - Comportamiento esperado, los filósofos comen" >> $LOG_FILE
  else
    echo "[FAIL] $description - Comportamiento inesperado" >> $LOG_FILE
  fi
}

test_case5() {
  local args="$1"
  local description="$2"
  local test_exit_file="$EXIT_DIR/test_concurrency_${description// /_}.txt"
  local valgrind_file="$VALGRIND_DIR/${description// /_}_valgrind.txt"

  timeout 20 ./philo $args > "$test_exit_file" 2>&1
  local exit_code=$?

if [ -s "$test_exit_file" ]; then
    echo "[FAIL] $description - Archivo de salida no está vacío" >> $LOG_FILE
else
    echo "[PASS] $description - Archivo de salida está vacío como se esperaba" >> $LOG_FILE
fi
}

test_case2() {
  local args="$1"
  local description="$2"
  local test_exit_file="$EXIT_DIR/test_concurrency_${description// /_}.txt"
  local valgrind_file="$VALGRIND_DIR/${description// /_}_valgrind.txt"

  timeout 60 ./philo $args > "$test_exit_file" 2>&1
  local exit_code=$?

  if grep -q "Error" "$test_exit_file"; then
    echo "[FAIL] $description - Error detectado en salida estándar" >> $LOG_FILE
  elif grep -q "died" "$test_exit_file"; then
    echo "[PASS] $description - Muerte detectada correctamente" >> $LOG_FILE
  elif grep -q "is eating" "$test_exit_file"; then
    echo "[PASS] $description - Comportamiento esperado, los filósofos comen" >> $LOG_FILE
  else
    echo "[FAIL] $description - Comportamiento inesperado" >> $LOG_FILE
  fi

 timeout 60  valgrind --tool=helgrind --log-file="$valgrind_file" ./philo $args > /dev/null
  if grep -q "0 errors from 0 contexts" "$valgrind_file"; then
    echo "[PASS] $description - Sin condiciones de carrera (Hellgrind)" >> $LOG_FILE
  else
    echo "[FAIL] $description - Condiciones de carrera detectadas (Hellgrind)" >> $LOG_FILE
  fi

  timeout 60  valgrind --leak-check=full --show-leak-kinds=all --log-file="$valgrind_file" ./philo $args > /dev/null
  if grep -q "All heap blocks were freed" "$valgrind_file"; then
    echo "[PASS] $description - Sin fugas de memoria detectadas (Memcheck)" >> $LOG_FILE
  else
    echo "[FAIL] $description - Fugas de memoria detectadas (Memcheck)" >> $LOG_FILE
  fi
}


# 1. Entradas mínimas
test_case4 "2 800 200 200" "Número mínimo de filósofos (2)"

# 2. Filósofos en gran cantidad
test_case4 "400 800 200 200" "Simulación con 400 filósofos"

# 3. Tiempos bajos
test_case "5 1 1 1" "Tiempos demasiado bajos (posible condición de carrera)"

# 4. **Errores Comunes del Usuario**
test_case3 "NULL" "Entrada NULL"
test_case3 "" "Entrada vacia"
test_case3 "abc def ghi" "Entrada con caracteres alfabéticos"
test_case3 "1 800 200 &" "Carácter especial en los argumentos"
test_case3 "-1 800 200 200" "Número negativo en argumentos"
test_case5 "0 800 200 200" "Cero como número de filósofos"

# 5. Tiempos altos
test_case2 "5 10000 5000 5000" "Tiempos extremadamente altos"


echo "Pruebas intensivas completadas. Ver resultados en $LOG_FILE y salidas en $EXIT_DIR. Informes de Valgrind en $VALGRIND_DIR."