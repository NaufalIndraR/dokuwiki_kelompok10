# acl.auth.php
# <?php exit()?>
# Don't modify the lines above
#
# Access Control Lists
#
# none   0
# read   1
# edit   2
# create 4
# upload 8
# delete 16

*               @ALL          1
*               @user         8
*               @admin        16
komdat:*        @ALL          1
komdat:*        @user         8
komdat:*        @admin        16
