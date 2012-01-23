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
#rails generate migration add_send_cheil_to_briefs send_to_cheil:string
#rails generate migration create_rpms_cheils
#rails generate controller rpm_orgs
#rails generate scaffold rpm_org 
#rails generate scaffold cheil_org 
#rails generate scaffold vendor_org 

#rails generate migration add_rpm_org_id_to_orgs rpm_org_id:integer
#rails generate migration rename_role_to_type_in_orgs
#rails generate migration add_cheil_id_to_briefs cheil_id:integer
#rails g model brief_attach brief_id:integer

#rails destroy scaffold brief_comment  

#rails g migration drop_brief_comment
#rails generate scaffold comment content:string type:string fk_id:integer user_id:integer 

#rails generate migration change_content_type  

#rails g scaffold attach fk_id:integer type:string user_id:integer
#rails destroy model brief_attach
#rails g migration drop_brief_attach
#rails g model solution brief_id:integer org_id:integer type:string is_sent:string

#rails g migration add_and_remove_columns_items

#rails destroy controller rpm

#rails g web_app_theme:theme --theme="blue"
#rails g web_app_theme:theme sign --layout-type=sign
#rails g controller solutions
#rails g migration add_type_to_users 
#rails g controller sessions new create destroy

#rails g migration add_note_to_items
#rails g migration add_checked_to_attaches

#rails g web_app_theme:theme --no-layout
#rails g web_app_theme:theme --theme=bec --no-layout
#rails g web_app_theme:theme --theme=red --no-layout
#rails g web_app_theme:theme --theme=amro --no-layout
#rails g kaminari:config
#rails g kaminari:views default
#rails g kaminari:views google 
#rails g kaminari:views github 

#rails g migration add_rate_to_solutions
#rails generate scaffold payer name:string

#rails g migration add_approved_to_solutions

#rails g scaffold payment solution_id:integer payer_id:integer org_id:integer amount:string pay_date:date note:string

#rails g migration remove_org_id_from_payment

#rails g migration add_read_by_to_briefs
#rails g migration add_read_by_to_attaches
#rails g migration add_read_by_to_solutions
#rails g migration add_read_by_to_items
#rails g migration add_indexs
#rails g migration add_status_to_briefs
#rails g migration add_cancel_to_briefs
#rails g migration add_finish_at_to_solutions
#rails generate controller pages
rails generate controller brief_items
