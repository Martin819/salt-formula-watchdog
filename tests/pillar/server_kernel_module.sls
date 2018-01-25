watchdog:
  server:
    enabled: true
    timeout: 60
    kernel:
      parameters:
        soft_panic: 1
        parameter: second
        value_only: none
    kernel_module:
      
