Role Name
=========
updatepackages

Requirements
------------
Use $ dpkg -l | grep {[ package }} to find the full package name and version.

Role Variables
--------------
package - Package name
version - Package version

Example Playbook
----------------

    - hosts: all
      roles:
         - { role: 'update_package' }

License
-------

BSD

Author Information
------------------

For all questions contact with asamuila
