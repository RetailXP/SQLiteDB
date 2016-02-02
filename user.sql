-- sqlite3 4YDP.db

-- Tracks information that is common to one design - it does not track the information regarding color or size.
-- The FOOTWEAR DESIGN DETAILS table is not directly related to the BARCODE DETAILS table. But the mapping between the BARCODE DETAILS and the FOOTWEAR DESIGN DETAILS tables will be made in the BARCODE DETAILS table.
-- The main purpose the FOOTWEAR DESIGN DETAILS table is to avoid duplicate informations in BARCODE DETAILS table
-- Primarily interacts with the tablet application

CREATE TABLE FOOTWEAR_DESIGN_DETAILS
(
    FootwearDesignId INTEGER PRIMARY KEY NOT NULL,
    ProductName VARCHAR(30) NOT NULL,
    BrandName VARCHAR(30) NOT NULL,
    Description VARCHAR(50),
    Cost DECIMAL(4,2) NOT NULL
);

-- Tracks the availability of different selections/colour and the corresponding pictures
-- Assume that only one picture is to be shown
-- This is to avoid having to track the same picture for multiple sizes of a footwear; thus the FOOTWEAR SELECTION DETAILS table is independent of the size attribute
-- Primarily used by the BARCODE DETAILS table

CREATE TABLE FOOTWEAR_SELECTION_DETAILS
(
    FootwearSelectionId INTEGER PRIMARY KEY NOT NULL,
    FootwearDesignDetailsFk INTEGER NOT NULL,
    Selection VARCHAR(30) NOT NULL,
    Picture BLOB NOT NULL,
    FOREIGN KEY(FootwearDesignDetailsFk) REFERENCES FOOTWEAR_DESIGN_DETAILS(FootwearDesignId)
);

-- Maps barcodes into unique unsigned integers and 
-- Provides the associated information that the barcode entails
-- Assumption:
-- Considering that the robotics solution is store specific, it is assumed that one barcode standard - one of UPC(Universal Product Code) or EAN(International Article Number) - is used throughout the store.
-- The distinction between the two standards could be made by observing the string length; EAN is 13 digits long while UPC is 12 digits long. If this turns out to be a cumbersome operation, an additional column could be added to track the type.
-- The total inventory count for a specific barcode will be tracked here. However, the number of inventory available for “checkout” will be separately tracked.
-- Primarily used by the tablet application

CREATE TABLE BARCODE_DETAILS
(
    BarcodeId INTEGER PRIMARY KEY NOT NULL,
    Barcode VARCHAR(13) NOT NULL,
    FootwearSelectionDetailsFk INTEGER NOT NULL,
    US_size DECIMAL(2,1) NOT NULL,
    EUR_size DECIMAL(2,1) NOT NULL,
    UK_size DECIMAL(2,1) NOT NULL,
    Gender CHAR(1) NOT NULL,
    FOREIGN KEY(FootwearSelectionDetailsFk) REFERENCES FOOTWEAR_SELECTION_DETAILS(FootwearSelectionId)
);

-- this is where the “available for checkout” count is calculated
-- Primarily used by the inventory robot and the tablet application

CREATE TABLE INVENTORY_INFO
(
    InventoryDetailsId INTEGER PRIMARY KEY NOT NULL,
    BarcodeDetailsFk INTEGER NOT NULL,
    X_index INTEGER NOT NULL,
    Y_index INTEGER NOT NULL,
    FOREIGN KEY(BarcodeDetailsFk) REFERENCES BARCODE_DETAILS(BarcodeId)
);

-- This is primarily used by the customer rewards card management

CREATE TABLE CUSTOMER_INFO
(
    CustomerInfoId INTEGER PRIMARY KEY NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50),
    LastName VARCHAR(50) NOT NULL,
    Address VARCHAR(50),
    PhoneNumber VARCHAR(20)
);

-- This is primarily used by the customer rewards card management

CREATE TABLE VIRTUAL_CART
(
    VirtualCartId INTEGER PRIMARY KEY NOT NULL,
    CustomerInfoFk INTEGER NOT NULL,
    BarcodeDetailsFk INTEGER NOT NULL,
    NumCheckedOut INTEGER NOT NULL,
    FOREIGN KEY(CustomerInfoFk) REFERENCES CUSTOMER_INFO(CustomerInfoId),
    FOREIGN KEY(BarcodeDetailsFk) REFERENCES BARCODE_DETAILS(BarcodeId)
);
