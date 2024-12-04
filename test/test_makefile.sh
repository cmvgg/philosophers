#!/bin/bash
mkdir -p logs exits

echo "=== Verificando Entregables ==="

if [ -f "Makefile" ]; then
    echo "[PASS] Makefile presente" >> logs/test_makefile.log
else
    echo "[FAIL] Makefile no encontrado" >> logs/test_makefile.log
    exit 1
fi

for target in all clean fclean re; do
    make $target &>/dev/null
    if [ $? -eq 0 ]; then
        echo "[PASS] make $target funciona correctamente" >> logs/test_makefile.log
    else
        echo "[FAIL] make $target falló" >> logs/test_makefile.log
    fi
done
