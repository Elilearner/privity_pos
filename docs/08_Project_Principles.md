# Principios del proyecto PRIVITY DRINK

## Arquitectura

- Las pantallas no contienen lógica de negocio.
- Toda la lógica vive en Services.
- Los Models no acceden a la UI.
- Todo dato compartido pasa por ServiceLocator.

## Diseño

- Tema oscuro.
- Color principal dorado.
- Moneda RD$.
- Botones principales de 50 px de alto.

## Código

- Utilizar dart format antes de finalizar una sesión.
- Documentar cada módulo importante.
- Evitar duplicación de lógica.
- Crear utilidades reutilizables (CurrencyFormatter, DateTimeFormatter, etc.).

## Objetivo

Construir un POS profesional, escalable y fácil de mantener.