name: New package validation
about: Submit a new package validation
title: 'Package validation: XXX version YYY'
labels: ['Package', 'Validation']
body:
  - type: markdown
    attributes:
      value: |
        Package validation report
  - type: input
    id: package
    attributes:
      label: pkg
      description: Which package has been validated?
    validations:
      required: true
  - type: input
    id: version
    attributes:
      label: version
      description: Which version of the package has been validated?
    validations:
      required: true
  - type: input
    id: name
    attributes:
      label: name
      description: What is your name?
    validations:
      required: true



