# SQLonAir by EffortlessAPI
#### Readonly, Calculated Fields for SQL Server

## CSV SSoT
This repo uses a CSV file to describe the Calculated Fields to be added to the existing, normalized SQL Server Data Model.

## Setting up the Demo
There are some primary resources used to run the demo.  The first is:

`/LEGACY_DB/PopulateSampleDB.sql`
This script will Create and then Use a database called SQLonAir used by the demo.  It then drops and/or re-creates the 4 tables (Customer, Product, ShoppingCart & CartItem) in the database.  It then populates the tables with
2 Products, 3 customers, 3 carts and 5 cart items.

`/PupblishSQLonAirDb.bat`
<b>Please Note:<br></b>
This script assumes that the SQL Instance is called `.\SQL2019` - change `SyncSQLonAirDb.bat` to reflect your instance name if needed.

Calling this publish script will use the `LEGACY_DB/SqlSchema/SqlSchema.xml` as the source schema, and creates a new folder not in the original REPO called:
`/SQLonAir/` which is where all the SQL on Air resources are put.

`/SQLonAir/CalculatedFields.csv`
This will initially have 1 sample "hello world" lookup field defined - but
you can add others and then call `PublishSQLonAirDb.bat` to generate new resources and update the local db [SQLonAir] with the new calulated fields.

`/CalculatedFiels.csv`
This is a demo version of the CSV with 18 sample calculated fields pre populated.

### Documentation
`/LEGACY_DB/docs/SinglePageDocs.html`
A single page description of the original, unmodified SQL Server schema.

`/SQLonAir/SQLonAirSchema/SinglePageDocs.html`
A single page description of the full schema, including all calculated fields defined by the `CalculatedFields.csv` file.

`/SQLonAir/SQLonAir_TechSpec.html`
A technical description of all calculated fields, along with their cascading dependancies, mapping out exactly which fields will be updated given any specific change.

### Lookup Columns
|ColumnName|Description|Example|
|--|--|--|
|TableName|The name of the table with the calculated field|Invoice
|FieldName|The name of the calculated field to be added|ShipToPhoneNumber
|LocalJoinFieldName|The name of the column to join on to find the parent value|ShipToCustomer
|RemoteTableName|The table to perform a lookup through|Customer
|RemoteFieldName|The name of the field in the linked table to lookup|PhoneNumber

### Calculated Fields
|ColumnName|Description|Example|
|--|--|--|
|TableName|The name of the table with the calculated field|Invoice
|FieldName|The name of the calculated field to be added|AmountDue
|Calculation|The calculation to perform|IF(NOW() > DATEADD(InvoiceDate, 30, day), InvoiceTotal, 0)

### Aggregate Columns
|ColumnName|Description|Example|
|--|--|--|
|TableName|The name of the table with the calculated field|Customer
|FieldName|The name of the calculated field to be added|AmountDue
|RemoteTableName|The related table aggregate values from|Invbvoice
|RemoteFieldName|AmountDue
|AggregateFunction|The function like sum, avg or max to apply|sum(values)
|AggregateWhereClause|A limit to apply to an aggregate dataset before applying the aggregate function.|IsVoid=false



## Sample `CalculatedFields.csv` file
|TableName|FieldName|FieldType|Calculation|LocalJoinFieldName|RemoteTableName|RemoteFieldName|AggregateFunction|AggregateWhereClause|Description__________________________________________________|
|-|-|-|-|-|-|-|-|-|-|
|Invoice|InvoiceTotal|Aggregation|||LineItem|SubTotal|sum(values)||Sum all LineItem SubTotals for all invoices.
|Invoice|AmountDue|Calculation|IF(NOW() > DATEADD(InvoiceDate, 30, day), InvoiceTotal, 0)||||||Show the amount due as $0 until 30 days after the invoice date, then it shows the InvoiceTotal calculated above.
|Customer|AmountDue|Aggregation|||Invoice|AmountDue|sum(values)|IsVoid=false|Sums the AmountDue (calculated above) on all customer invoices which are not Void.
|Invoice|ShipToPhoneNumber|Lookup||ShipToCustomerId|Customer|PhoneNumber|||Shows the phone number for the customer linked to the ShipToCustomerId
|Invoice|BillToPhoneNumber|Lookup||BillToCustomerId|Customer|PhoneNumber|||Shows the phone number for the customer linked to the BIllToCustomerId
