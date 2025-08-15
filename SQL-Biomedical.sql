-- STEP 1: Create the schema
CREATE SCHEMA IF NOT EXISTS biomedical_schema;

-- STEP 2: Use the schema
USE biomedical_schema;

-- STEP 3: Create Biomedical Research Fields table
CREATE TABLE biomedical_schema.Biomedical_Research_Field (
    Field_ID INT AUTO_INCREMENT PRIMARY KEY,
    Field_Name VARCHAR(255) UNIQUE NOT NULL
);

-- STEP 4: Create Authors table
CREATE TABLE biomedical_schema.Author (
    Author_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Qualification VARCHAR(100),
    Affiliation VARCHAR(255),
    Job_Title VARCHAR(100),
    Email VARCHAR(255) UNIQUE,
    h_index INT
);

-- STEP 5: Create Author-Field (many-to-many) relationship table
CREATE TABLE biomedical_schema.Author_Field (
    Author_ID INT,
    Field_ID INT,
    PRIMARY KEY (Author_ID, Field_ID),
    FOREIGN KEY (Author_ID) REFERENCES biomedical_schema.Author(Author_ID) ON DELETE CASCADE,
    FOREIGN KEY (Field_ID) REFERENCES biomedical_schema.Biomedical_Research_Field(Field_ID) ON DELETE CASCADE
);

-- STEP 6: Create Publisher table
CREATE TABLE biomedical_schema.Publisher (
    Publisher_ID INT AUTO_INCREMENT PRIMARY KEY,
    Publisher_Name VARCHAR(255) NOT NULL,
    Publication_Types VARCHAR(255),
    Payment_Methods VARCHAR(255)
);

-- STEP 7: Create Journal table
CREATE TABLE biomedical_schema.Journal (
    ISSN VARCHAR(20) PRIMARY KEY,
    Journal_Name VARCHAR(255) NOT NULL,
    Biomedical_Research_Field VARCHAR(255),
    Impact_Factor DECIMAL(4,2),
    Quarter VARCHAR(20),
    Publisher_ID INT,
    Country VARCHAR(100),
    Start_Date DATE,
    Volume_Publication_Rate ENUM('Monthly', 'Quarterly', 'Annually'),
    Open_Access_Status BOOLEAN,
    FOREIGN KEY (Publisher_ID) REFERENCES biomedical_schema.Publisher(Publisher_ID) ON DELETE SET NULL
);

-- STEP 8: Create Research table
CREATE TABLE biomedical_schema.Research (
    Research_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title TEXT NOT NULL,
    Abstract TEXT,
    Publication_Date DATE,
    Research_Field VARCHAR(255),
    Journal_ID VARCHAR(20),
    Citations INT DEFAULT 0,
    Year INT,
    FOREIGN KEY (Journal_ID) REFERENCES biomedical_schema.Journal(ISSN) ON DELETE SET NULL
);

-- STEP 9: Create Research-Author (many-to-many) relationship table
CREATE TABLE biomedical_schema.Research_Author (
    Research_ID INT,
    Author_ID INT,
    PRIMARY KEY (Research_ID, Author_ID),
    FOREIGN KEY (Research_ID) REFERENCES biomedical_schema.Research(Research_ID) ON DELETE CASCADE,
    FOREIGN KEY (Author_ID) REFERENCES biomedical_schema.Author(Author_ID) ON DELETE CASCADE
);

-- STEP 10: Insert Biomedical Research Fields
INSERT INTO biomedical_schema.Biomedical_Research_Field (Field_Name) VALUES 
('Immunology'),
('Genetics'),
('Cell and Developmental Biology'),
('Neuroscience'),
('Pharmacology'),
('Molecular Biology'),
('Biochemistry'),
('Microbiology'),
('Pathology'),
('Bioinformatics'),
('Epidemiology');

-- STEP 11: Insert Authors (Egyptian Focus)
INSERT INTO biomedical_schema.Author (Name, Qualification, Affiliation, Job_Title, Email, h_index) VALUES
('Dr. Amina Nassar', 'PhD', 'Ain Shams University', 'Professor', 'amina.nassar@asu.edu.eg', 38),
('Dr. Hossam Eldin Mostafa', 'MD, PhD', 'Cairo University', 'Lecturer', 'h.mostafa@cu.edu.eg', 33),
('Dr. Mona Farouk', 'PhD', 'Mansoura University', 'Associate Professor', 'm.farouk@mans.edu.eg', 40),
('Dr. Youssef Galal', 'PhD', 'Zewail City of Science', 'Research Scientist', 'y.galal@zewailcity.edu.eg', 29),
('Dr. Salma Saad', 'MD', 'Alexandria University', 'Assistant Professor', 's.saad@alexu.edu.eg', 27),
('Dr. Tarek Hussein', 'PhD', 'Nile University', 'Associate Professor', 't.hussein@nileu.edu.eg', 35),
('Dr. Rania El-Masry', 'PhD', 'National Research Centre', 'Senior Researcher', 'r.elmasry@nrc.gov.eg', 42),
('Dr. Ahmed Magdy', 'PhD', 'Helwan University', 'Lecturer', 'ahmed.magdy@hu.edu.eg', 31),
('Dr. Noha Hassan', 'PhD', 'AUC', 'Postdoctoral Fellow', 'n.hassan@aucegypt.edu', 28),
('Dr. Kareem Zaki', 'PhD', 'October 6 University', 'Lecturer', 'k.zaki@o6u.edu.eg', 30);

-- STEP 12: Link Authors to Fields
INSERT INTO biomedical_schema.Author_Field (Author_ID, Field_ID) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- STEP 13: Insert Publishers
INSERT INTO biomedical_schema.Publisher (Publisher_Name, Publication_Types, Payment_Methods) VALUES
('Egyptian Medical Journal Press', 'Journals', 'Online Payment'),
('Cairo Scientific Publishing', 'Books, Journals', 'Bank Transfer'),
('MISR Academic Press', 'Journals, Magazines', 'Cash, Bank Transfer'),
('NRC Publishing', 'Journals', 'Online Payment'),
('Zewail Research Publications', 'Journals, eBooks', 'Online Payment');

-- STEP 14: Insert Journals
INSERT INTO biomedical_schema.Journal (ISSN, Journal_Name, Biomedical_Research_Field, Impact_Factor, Quarter, Publisher_ID, Country, Start_Date, Volume_Publication_Rate, Open_Access_Status) VALUES
('1001-2345', 'Journal of Egyptian Immunology', 'Immunology', 2.75, 'Q3', 1, 'Egypt', '2005-03-01', 'Quarterly', TRUE),
('1002-3456', 'Genetic Studies Egypt', 'Genetics', 3.10, 'Q2', 2, 'Egypt', '2008-07-15', 'Monthly', FALSE),
('1003-4567', 'Cairo Cell Biology Reports', 'Cell and Developmental Biology', 2.90, 'Q4', 3, 'Egypt', '2012-01-01', 'Annually', TRUE),
('1004-5678', 'NeuroEgypt', 'Neuroscience', 4.20, 'Q2', 4, 'Egypt', '2015-05-10', 'Quarterly', TRUE),
('1005-6789', 'Egyptian Pharmacology Letters', 'Pharmacology', 3.75, 'Q1', 1, 'Egypt', '2011-02-20', 'Monthly', FALSE),
('1006-7890', 'Molecular Egypt Journal', 'Molecular Biology', 2.80, 'Q3', 2, 'Egypt', '2013-08-01', 'Annually', TRUE),
('1007-8901', 'Alex Biochemistry Journal', 'Biochemistry', 3.40, 'Q3', 3, 'Egypt', '2014-10-10', 'Quarterly', TRUE),
('1008-9012', 'Egyptian Journal of Microbial Research', 'Microbiology', 3.20, 'Q2', 4, 'Egypt', '2016-01-05', 'Monthly', TRUE),
('1009-0123', 'Pathology Insights Egypt', 'Pathology', 2.95, 'Q4', 5, 'Egypt', '2018-06-06', 'Quarterly', FALSE),
('1010-1234', 'Bioinformatics Nile Review', 'Bioinformatics', 3.65, 'Q1', 5, 'Egypt', '2020-09-09', 'Annually', TRUE);

-- STEP 15: Insert Research Articles
INSERT INTO biomedical_schema.Research (Title, Abstract, Publication_Date, Research_Field, Journal_ID, Citations, Year) VALUES
('Cytokine Profiling in Egyptian Asthmatic Patients', 'Investigation of immune response patterns in asthma.', '2023-03-12', 'Immunology', '1001-2345', 120, 2023),
('Genetic Mutation Patterns in Nile Delta Populations', 'Study of mutation frequencies in Egyptian genetics.', '2023-06-18', 'Genetics', '1002-3456', 89, 2023),
('Cell Division Irregularities and Tumor Growth', 'Linking mitotic defects to cancer in Egypt.', '2022-10-05', 'Cell and Developmental Biology', '1003-4567', 76, 2022),
('Neural Activity in Epileptic Egyptian Youth', 'EEG mapping and neurobehavioral studies.', '2024-01-22', 'Neuroscience', '1004-5678', 101, 2024),
('Pharmacokinetics of Traditional Egyptian Herbal Medicine', 'Clinical trials and drug interaction analysis.', '2022-07-09', 'Pharmacology', '1005-6789', 67, 2022),
('DNA Repair Mechanisms in Egyptian Cancer Patients', 'Comparative study of repair pathways.', '2021-12-11', 'Molecular Biology', '1006-7890', 80, 2021),
('Metabolic Pathways of Diabetic Patients in Alexandria', 'Biochemical analysis of metabolism.', '2023-02-14', 'Biochemistry', '1007-8901', 94, 2023),
('Antibiotic Resistance in Egyptian Hospitals', 'Tracking microbial evolution in healthcare.', '2023-04-04', 'Microbiology', '1008-9012', 123, 2023),
('Histopathological Changes in Liver Cirrhosis Cases', 'Diagnostic imaging and tissue correlation.', '2022-06-30', 'Pathology', '1009-0123', 65, 2022),
('Machine Learning in Egyptian Genomic Data', 'Application of AI in local bioinformatics.', '2023-11-11', 'Bioinformatics', '1010-1234', 135, 2023);

-- STEP 16: Link Authors to Research
INSERT INTO biomedical_schema.Research_Author (Research_ID, Author_ID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);


-- Additional Publishers (Egyptian-based)
INSERT INTO biomedical_schema.Publisher (Publisher_Name, Publication_Types, Payment_Methods) VALUES
('Faculty of Medicine Press, Cairo University', 'Journals, Monographs', 'Online Payment, Bank Transfer'),
('Egyptian Scientific Research Organization', 'Journals, Reports', 'Bank Transfer'),
('Delta Medical Publishers', 'Books, Journals', 'Cash, Online Payment'),
('Upper Egypt Science Press', 'Journals', 'Online Payment'),
('Suez Canal Academic Publishing', 'Journals, eBooks', 'Bank Transfer, Online Payment');

SELECT a.Name
FROM biomedical_schema.Author a
JOIN biomedical_schema.Author_Field af ON a.Author_ID = af.Author_ID
JOIN biomedical_schema.Biomedical_Research_Field bf ON af.Field_ID = bf.Field_ID
WHERE bf.Field_Name = 'Immunology';

SELECT a.Name, SUM(r.Citations) AS Total_Citations
FROM biomedical_schema.Author a
JOIN biomedical_schema.Research_Author ra ON a.Author_ID = ra.Author_ID
JOIN biomedical_schema.Research r ON ra.Research_ID = r.Research_ID
WHERE r.Year = 2023
GROUP BY a.Name
ORDER BY Total_Citations DESC
LIMIT 1;
SELECT j.Journal_Name
FROM biomedical_schema.Journal j
JOIN biomedical_schema.Publisher p ON j.Publisher_ID = p.Publisher_ID
WHERE j.Open_Access_Status = TRUE AND p.Publisher_Name LIKE '%Springer%';




-- Trigger: Log when a new research entry is inserted
CREATE TABLE IF NOT EXISTS Research_Log (
    Log_ID INT AUTO_INCREMENT PRIMARY KEY,
    Research_ID INT,
    Action VARCHAR(50),
    Action_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$
CREATE TRIGGER after_research_insert
AFTER INSERT ON Research
FOR EACH ROW
BEGIN
    INSERT INTO Research_Log (Research_ID, Action) VALUES (NEW.Research_ID, 'INSERT');
END$$
DELIMITER ;

