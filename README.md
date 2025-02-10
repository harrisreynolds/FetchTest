# Fetch Test README

This is a simple Rails application that calculates points based on a receipt.

The salient parts of the application are:

* `app/services/point_counter.rb` - This is the main class that calculates the points based on the receipt.
* `app/controllers/receipts_controller.rb` - This is the controller that handles the API requests.
* `spec/controllers/receipts_controller_spec.rb` - This is the spec file for the controller.

The Receipt model and the ReceiptStore are used to store and retrieve the receipts.  Both are found in the `app/data` directory.

The `ReceiptStore` is a simple in-memory store that is used to store the receipts.  It is not persisted to a database.

The `Receipt` model is a simple data structure that represents a receipt.  It is used to store the receipt data.

The `PointCounter` is a class that calculates the points based on the receipt.  It is used to calculate the points based on the receipt.

It utilizes a simple rule-based system to calculate the points.  The rules are defined in the `app/services` directory.

Tests are found in the `spec` directory.  The `spec/controllers/receipts_controller_spec.rb` file is the main spec file for the controller.

The tests are run using the `rspec` command.

Future improvements:

* Add a database to store the receipts.
* Add field level validation to the Receipt model.