cookbook_path ["cookbooks", "site-cookbooks"]
node_path     "nodes"
role_path     "roles"
data_bag_path "data_bags"
#encrypted_data_bag_secret "data_bag_key"

knife[:berkshelf_path] = "cookbooks"

cookbook_copyright "Naoto Kaneko"
cookbook_email     "naoty.k@gmail.com"
cookbook_license   "mit"
