Deface::Override.new(
  virtual_path: "spree/admin/return_authorizations/index",
  name: "add_ra_print_button",
  insert_bottom: 'td.actions span',
  partial: "spree/admin/return_authorizations/buttons"
)
