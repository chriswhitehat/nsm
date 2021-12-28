#
# Cookbook:: nsm
# Attributes:: steno
#
# Copyright:: 2021, The Authors, All Rights Reserved.

#####################
# Steno Defaults
#####################
default[:nsm][:steno][:grpc] = true
default[:nsm][:steno][:max_directory_files] = 750000
default[:nsm][:steno][:disk_free_percentage] = 5
default[:nsm][:steno][:port] = 15140
default[:nsm][:steno][:host] = '127.0.0.1'
# Set reserved memory (default: 8GB)
# Set file reallocate for xfs (default: 4GB)
#default[:nsm][:steno][:flags] = '["--blocks=8192", "--preallocate_file_mb=4096"]' 
default[:nsm][:steno][:flags] = '[]' 
