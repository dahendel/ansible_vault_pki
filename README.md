Vault_Certs
=========

Create and Delete PKI Backends in Hashicorp Vault. Created to have no additional dependencies

There is a pre_check that checks to see if the backend(s) exist. If the root ca backend exists and the intermediate does not,
the playbook will only execute `create_intermediate.yml and create_role.yml`, if both exist it will only execute `create_role.yml`

Requirements
------------

- python-requests
- VAULT_ADDR and VAULT_TOKEN env variables

Role Variables
--------------
- `ca_secret_name` - the name of the pki backend, the intermediate backend will have a suffix of `_int`

- `remove_ca` - delete the ca generated via `ca_secret_name` (default: false)

- `save_certs` - save the generated certificates locally (default: true)

- `domain` - domain for the certificates

- `local_cert_path` - path to save generated certificates to (default: "{{playbook_dir}}")

- `ca_ttl` - root ca ttl (default: 87600h)

- `intermediate_ttl` - intermediate cert ttl (default: 43800h)

- `root_ca_data` - a map of the root ca variables to pass, you should include config. You can include any valid keys
    ```yaml
    root_cat_data:
      generate_signing_key: true
      path: "{{ca_secret_name}}"
      type: pki
      config:
        max_lease_ttl: "{{ca_ttl}}" 
    ```
- `intermediate_cert_data` - intermediate cert options for creation
  ```yaml
  type: pki
  config:
    max_lease_ttl: "{{intermediate_ttl}}"
  ```

- `pki_roles` - a list of roles for the pki backend
  ```yaml
  - name: example-local
    config:
      allowed_domains: "{{domain}}"
      allow_subdomains: true
      max_ttl: 720h
  ```
Dependencies
------------

The only dependency is python-requests for the uri module. 

Example Playbook
----------------

Create:

    - hosts: local
      connectin: local
      gather_facts: no
      roles:
         - role: vault_certs 
           ca_secret_name: example
           domain: example.com

Delete:

    - hosts: local
      connectin: local
      gather_facts: no
      roles:
         - role: vault_certs 
           remove_ca: true
           
License
-------

Apache
