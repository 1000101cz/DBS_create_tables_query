CREATE TABLE ManufacturingPlant (
    plant_id SERIAL PRIMARY KEY,
    established DATE NOT NULL
);

CREATE TABLE Employee (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birthday DATE NOT NULL,
    personal_number INT NOT NULL,
    salary INT NOT NULL,
    position VARCHAR(50),
    UNIQUE (personal_number)
);

CREATE TABLE Location (
    plant SERIAL PRIMARY KEY CONSTRAINT location_fk_plant REFERENCES ManufacturingPlant(plant_id),
    street VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    zip INT NOT NULL,
    UNIQUE (plant)
);

CREATE TABLE Residence (
    employee SERIAL PRIMARY KEY CONSTRAINT location_fk_employee REFERENCES Employee(employee_id),
    street VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    zip INT NOT NULL,
    UNIQUE(employee)
);

CREATE TABLE EmailContact (
    employee SERIAL NOT NULL CONSTRAINT email_fk_employee REFERENCES Employee(employee_id),
    email VARCHAR(100) NOT NULL,
    PRIMARY KEY (employee, email),
    CONSTRAINT employee_ch_email CHECK (email LIKE '_%@_%.__%')
);

CREATE TABLE PhoneContact (
    employee SERIAL NOT NULL CONSTRAINT phone_fk_employee REFERENCES Employee(employee_id),
    phone VARCHAR(20) NOT NULL,
    PRIMARY KEY (employee, phone)
);

CREATE TABLE EmployedIn (
    employee SERIAL NOT NULL CONSTRAINT employedin_fk_employee REFERENCES Employee(employee_id),
    plant SERIAL NOT NULL CONSTRAINT employedin_fk_plant REFERENCES ManufacturingPlant(plant_id),
    PRIMARY KEY (employee, plant)
);

CREATE TABLE ProductModel (
    model_id SERIAL PRIMARY KEY,
    product_type VARCHAR(50) NOT NULL,
    model_version INT NOT NULL,
    UNIQUE (product_type, model_version)
);

CREATE TABLE ModelDevelopedBy (
    model SERIAL NOT NULL CONSTRAINT modeldeveloped_fk_model REFERENCES ProductModel(model_id),
    employee SERIAL NOT NULL CONSTRAINT modeldeveloped_fk_employee REFERENCES Employee(employee_id),
    PRIMARY KEY (model, employee)
);

CREATE TABLE ProductionLine (
    line_id SERIAL PRIMARY KEY,
    plant SERIAL NOT NULL CONSTRAINT lineloc_fk_plant REFERENCES ManufacturingPlant(plant_id),
    master SERIAL NOT NULL CONSTRAINT linemaster_fk_employee REFERENCES Employee(employee_id),
    production_capacity INT NOT NULL
);

CREATE TABLE Machine (
    machine_id SERIAL PRIMARY KEY,
    machine_type VARCHAR(50) NOT NULL,
    line_id SERIAL NOT NULL CONSTRAINT machineloc_fk_line REFERENCES ProductionLine(line_id),
    master SERIAL NOT NULL CONSTRAINT machinemaster_fk_employee REFERENCES Employee(employee_id)
);

CREATE TABLE MachineMaintainedBy (
    machine SERIAL NOT NULL CONSTRAINT machinemaintain_fk_machine REFERENCES Machine(machine_id),
    employee SERIAL NOT NULL CONSTRAINT machinemaintain_fk_employee REFERENCES Employee(employee_id),
    PRIMARY KEY (machine, employee)
);

CREATE TABLE MachineOperatedBy (
    machine SERIAL NOT NULL CONSTRAINT machinemaintain_fk_machine REFERENCES Machine(machine_id),
    employee SERIAL NOT NULL CONSTRAINT machinemaintain_fk_employee REFERENCES Employee(employee_id),
    PRIMARY KEY (machine, employee)
);

CREATE TABLE Product (
    product_id SERIAL PRIMARY KEY,
    created TIMESTAMP NOT NULL,
    model INT NOT NULL CONSTRAINT product_fk_model REFERENCES ProductModel(model_id),
    machine SERIAL NOT NULL CONSTRAINT product_fk_machine REFERENCES Machine(machine_id),
    result_state VARCHAR(3) CHECK (result_state in ('OK', 'NOK'))
);

CREATE TABLE ProcessData (
    product SERIAL NOT NULL CONSTRAINT processdata_fk_product REFERENCES Product(product_id),
    data_desc VARCHAR(20) NOT NULL,
    process_data DOUBLE PRECISION[] NOT NULL,
    PRIMARY KEY (product, process_data)
);

CREATE TABLE ProductAnalysedBy (
    product SERIAL NOT NULL CONSTRAINT productanalysed_fk_product REFERENCES Product(product_id),
    employee SERIAL NOT NULL CONSTRAINT productanalysed_fk_employee REFERENCES Employee(employee_id),
    PRIMARY KEY (product, employee)
);
