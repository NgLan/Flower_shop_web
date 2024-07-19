CREATE DATABASE Organic_Shop;
USE DATABASE Organic_Shop;

CREATE TABLE Category (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Type NVARCHAR(255) NOT NULL
);

CREATE TABLE Product (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    CategoryID INT NOT NULL,
    Unit NVARCHAR(50) NOT NULL,
    Description TEXT NOT NULL,
    CONSTRAINT FK_CategoryProduct FOREIGN KEY (CategoryID) REFERENCES Category(ID)
);

CREATE TABLE Variant (
	ID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    Colour NVARCHAR(50) NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    -- CONSTRAINT PK_Variant PRIMARY KEY (ProductID, Colour),
    CONSTRAINT FK_ProductVariant FOREIGN KEY (ProductID) REFERENCES Product(ID)
);

CREATE TABLE [User] (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Email VARCHAR(320) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Name NVARCHAR(255) NOT NULL,
    Phone CHAR(10) NOT NULL,
    Address TEXT NOT NULL
);

CREATE TABLE Cart (
    VariantID INT NOT NULL,
    Quantity INT NOT NULL,
    Time DATETIME NOT NULL,
    CONSTRAINT PK_Cart PRIMARY KEY (VariantID, Time),
    CONSTRAINT FK_VariantCart FOREIGN KEY (VariantID) REFERENCES Variant(ID)
);

CREATE TABLE VoucherType (
    ID INT PRIMARY KEY IDENTITY(1,1),
	Type NVARCHAR(255) NOT NULL -- Giảm giá hoặc hoàn tiền hoặc giảm tiền ship
);

CREATE TABLE Voucher (
    ID INT PRIMARY KEY IDENTITY(1,1),
	Publisher INT NOT NULL, -- Nhà phát hành có thể là ID của shop/CLB/nền tảng/...
	VoucherTypeID INT NOT NULL,
	Amount INT NOT NULL,
	Unit TINYINT NOT NULL, -- Đơn vị: %, nghìn đồng, triệu đồng,...
	MaxDiscount INT NOT NULL, -- Giảm/Hoàn tối đa ... đồng
	MinOrder INT NOT NULL, -- Đơn tối thiểu ... đồng
    Description TEXT NOT NULL,
	CONSTRAINT FK_VoucherType FOREIGN KEY (VoucherTypeID) REFERENCES VoucherType(ID)
);

CREATE TABLE VoucherDetail (
	VoucherID INT NOT NULL,
    CategoryID INT NOT NULL,
    CONSTRAINT PK_VoucherDetail PRIMARY KEY (VoucherID, CategoryID),
    CONSTRAINT FK_VoucherDetail1 FOREIGN KEY (VoucherID) REFERENCES Voucher(ID),
    CONSTRAINT FK_VoucherDetail2 FOREIGN KEY (CategoryID) REFERENCES Category(ID)
);

CREATE TABLE [Order] (
    ID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    OrderTime DATETIME NOT NULL,
	VoucherID INT NOT NULL, -- Voucher của nền tảng
	ShipmentVoucherID INT NOT NULL,
	TotalPrice DECIMAL(18,2), -- = Tổng tiền sản phẩm + Tiền ship - Tiền giảm giá (sản phẩm và ship)
    CONSTRAINT FK_UserOrder FOREIGN KEY (UserID) REFERENCES [User](ID),
    CONSTRAINT FK_ShipmentVoucher FOREIGN KEY (ShipmentVoucherID) REFERENCES Voucher(ID),
	CONSTRAINT FK_VoucherOrder FOREIGN KEY (VoucherID) REFERENCES Voucher(ID)
);

CREATE TABLE OrderDetail (
    OrderID INT NOT NULL,
    VariantID INT NOT NULL,
	Quantity INT NOT NULL,
	VoucherID INT, -- Voucher Shop/CLB/..., không phải voucher của nền tảng
	ProductPrice DECIMAL(18,2) NOT NULL,
	ShipmentPrice DECIMAL(18,2) NOT NULL,
    CONSTRAINT PK_OrderDetail PRIMARY KEY (OrderID, VariantID),
    CONSTRAINT FK_OrderDetail FOREIGN KEY (OrderID) REFERENCES [Order](ID),
    CONSTRAINT FK_Variant_OrderDetail FOREIGN KEY (VariantID) REFERENCES Variant(ID),
    CONSTRAINT FK_ProductVoucher FOREIGN KEY (VoucherID) REFERENCES Voucher(ID)
);

CREATE TABLE Shipment (
    ID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
	ReceiveTime DATETIME,
	DeliveryTime DATETIME,
    CONSTRAINT FK_OrderShipment FOREIGN KEY (OrderID) REFERENCES [Order](ID)
);

CREATE TABLE PaymentMethod (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Method NVARCHAR(255)
);

CREATE TABLE Payment (
    ID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
	PaymentMethodID INT NOT NULL,
	Time DATETIME NOT NULL,
    CONSTRAINT FK_OrderShipment FOREIGN KEY (OrderID) REFERENCES [Order](ID),
	CONSTRAINT FK_PaymentMethod FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethod(ID)
);

CREATE TABLE Review (
    UserID INT NOT NULL,
	OrderID INT NOT NULL,
    Review TEXT NOT NULL,
    CONSTRAINT PK_Review PRIMARY KEY (UserID, OrderID),
    CONSTRAINT FK_UserReview FOREIGN KEY (UserID) REFERENCES [User](ID),
    CONSTRAINT FK_OrderReview FOREIGN KEY (OrderID) REFERENCES [Order](ID)
);
