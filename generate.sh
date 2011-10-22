#!/bin/sh
#rails generate scaffold admin_user name:string hashed_password:string salt:string
#rails generate scaffold user name:string hashed_password:string salt:string email:string phone:string org_id:integer

#rails generate scaffold org name:string role:string
#rails generate scaffold brief name:string user_id:integer org_id:integer
#rails generate controller rpm cheil vendor
#rails generate controller  vendor
#rails generate controller cheil

#rails generate scaffold brief_comment content:string brief_id:integer user_id:integer 
#rails generate scaffold brief_vendor brief_id:integer org_id:integer approved:string
#rails generate scaffold item brief_id:integer quantity:string price:string kind:string parent_id:integer vendor_id:integer checked:string
rails generate migration add_send_cheil_to_briefs send_to_cheil:string
