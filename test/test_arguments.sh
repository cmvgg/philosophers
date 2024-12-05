#!/bin/bash

mkdir -p exits logs

EXIT_DIR="exits"
LOG_FILE="logs/out_of_range_strict.log"

rm -f $LOG_FILE

echo "=== Verificando Invalid Arguments y Casos Funcionales ==="

test_case() {
  local args="$1"
  local description="$2"
  local expected_behavior="$3"
  local test_exit_file="$EXIT_DIR/test_out_of_range_${description// /_}.txt"

  timeout 5 ./philo $args > "$test_exit_file" 2>&1
  local exit_code=$?

  if [ "$expected_behavior" == "error" ]; then
    if grep -q "Error" "$test_exit_file"; then
      echo "[PASS] $description - Error detectado correctamente" >> $LOG_FILE
    elif [ $exit_code -ne 0 ]; then
      echo "[PASS] $description - Programa terminó con error (exit code $exit_code)" >> $LOG_FILE
    else
      echo "[FAIL] $description - Programa no detectó el error" >> $LOG_FILE
    fi
  elif [ "$expected_behavior" == "valid" ]; then
    if [ $exit_code -eq 0 ]; then
      echo "[PASS] $description - Comportamiento válido como esperado" >> $LOG_FILE
    else
      echo "[FAIL] $description - Comportamiento no esperado (exit code $exit_code)" >> $LOG_FILE
    fi
  elif [ "$expected_behavior" == "silence" ]; then
    if [ ! -s "$test_exit_file" ]; then
      echo "[PASS] $description - No hay salida, comportamiento esperado" >> $LOG_FILE
    else
      echo "[FAIL] $description - Salida inesperada en el programa" >> $LOG_FILE
    fi
  fi
}

# 1. Valores fuera de rango
test_case "2147483648 800 200 200" "Mayor a INT_MAX" "error"
test_case "-2147483649 800 200 200" "Menor a INT_MIN" "error"
test_case "9999999999 800 200 200" "Extremadamente grande" "error"
test_case "800 800 200 200 -2147483649" "Mix válido e inválido (menor a INT_MIN)" "error"
test_case "2147483648 800 200 200 800" "Mix válido e inválido (mayor a INT_MAX)" "error"

# 2. Casos funcionales específicos
test_case "1 1 1 1" "Todos los argumentos iguales" "valid"
test_case "1 800 200 200 0" "Cero como argumento final" "silence"

# 3. Entradas no numéricas
test_case "abc 800 200 200" "Texto en lugar de número" "error"
test_case "1 800 xyz 200" "Texto entre argumentos válidos" "error"
test_case "" "Sin argumentos" "error"

# 4. Carácteres especiales
test_case "@#$% 800 200 200" "Caracteres especiales como argumentos" "error"
test_case "800 200 200 !@#" "Mix de valores y caracteres especiales" "error"
test_case ";" "Solo punto y coma" "error"

# 5. Overflow simulado
test_case "1000000000 1000000000 1000000000 1000000000" "Valores grandes simulando overflow" "error"

echo "Pruebas completadas. Ver resultados en $LOG_FILE y salidas en $EXIT_DIR."
