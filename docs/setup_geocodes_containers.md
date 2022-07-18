##  Setup Geocodes Containers:

  * Setup and start services using portainer ui
    * log into portainer
    * stack tab
    * Create Services Stack
      * add stack button
          * Name: services
          * Build method: git repository
          * Repository URL: https://github.com/earthcube/geocodes
          * reference: refs/heads/main
          * Compose path: deployment/services-compose.yaml
          * Environment variables: click 'load variables from .env file'
            * load {myhost}.env
          * Actions: 
            * Click: Deploy This Stack 
  ![Create Services Stack](./images/create_services.png)
    * Create Geocodes Stack
      * add stack button
        * Name: geocodes
        * Build method: git repository
        * Repository URL: https://github.com/earthcube/geocodes
        * reference: refs/heads/main
        * Compose path: deployment/geocodes-compose.yaml
        * Environment variables: click 'load variables from .env file'
          * load {myhost}.env
        * Actions:
          * Click: Deploy This Stack
    ![Create Geocodes Stack](./images/create_geocodes_stack.png)

    
