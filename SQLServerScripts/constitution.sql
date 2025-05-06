-- SQL Server Script to create the Constitution1996 DB by Marco Oppel ©2025
-- Table Contents except Amendments based on the actual Constitution found at: https://www.justice.gov.za/legislation/constitution/saconstitution-web-eng.pdf
-- Amendments table content was found on pages 2 - 3 from this book: https://juta.co.za/catalogue-details/constitution-of-the-republic-of-south-africa-1996-3_446
-- CONTENTS ACCURATE AS OF APRIL 2025

/*
	////////////////////////
	Create and use the Constitution1996 DB, and create the schemas
	////////////////////////
*/


DROP DATABASE IF EXISTS Constitution1996;

CREATE DATABASE Constitution1996;
GO

USE Constitution1996;
GO

CREATE SCHEMA AmendmentSchema;
GO
CREATE SCHEMA MainSchema;
GO
CREATE SCHEMA ScheduleSchema;
GO

/*
	/////////////////////
	Create the tables needed for each schema
	/////////////////////
*/

/* AmendmentSchema */

CREATE TABLE [AmendmentSchema].Amendments
(
	AmendmentID int PRIMARY KEY,
	AmendmentTitle nvarchar(60) NOT NULL,
	DateOfEffect Date NOT NULL,
	Reference nvarchar(175) NOT NULL
)
GO
CREATE UNIQUE INDEX AmendmentIndex ON [AmendmentSchema].Amendments(AmendmentTitle);
GO

/* END */

/* MainSchema */


CREATE TABLE [MainSchema].Chapters
(
	ChapterID int PRIMARY KEY,
	ChapterTitle nvarchar(60) NOT NULL
)
GO
CREATE UNIQUE INDEX ChapterTitleIndex ON [MainSchema].Chapters(ChapterTitle);
GO

CREATE TABLE [MainSchema].Sections
(
	SectionID int PRIMARY KEY,
	ChapterID int FOREIGN KEY REFERENCES [MainSchema].Chapters(ChapterID),
	SectionTitle nvarchar(100) NOT NULL,
	SectionText nvarchar(MAX)
)
GO
CREATE INDEX MainSectionTitleIndex ON [MainSchema].Sections(SectionTitle);
GO

CREATE TABLE [MainSchema].Subsections
(
    SubsectionID nvarchar(5),
    SectionID int FOREIGN KEY REFERENCES [MainSchema].Sections(SectionID),
    SubsectionText nvarchar(MAX) NOT NULL
	PRIMARY KEY(SectionID, SubsectionID)
)
GO

CREATE TABLE [MainSchema].Clauses
(
    ClauseID nvarchar(3),
    SectionID int,
    SubsectionID nvarchar(5),
    ClauseText nvarchar(MAX) NOT NULL,
    PRIMARY KEY(ClauseID, SectionID, SubsectionID),
    FOREIGN KEY (SectionID, SubsectionID) REFERENCES [MainSchema].Subsections(SectionID, SubsectionID)
)
GO

CREATE TABLE [MainSchema].NonDerogableRights (
    SectionNumber INT NOT NULL PRIMARY KEY,
    SectionTitle NVARCHAR(100) NOT NULL,
    ProtectionExtent NVARCHAR(500) NOT NULL,
    FOREIGN KEY (SectionNumber) REFERENCES [MainSchema].Sections(SectionID)
);
GO
CREATE UNIQUE INDEX NDRIndex ON [MainSchema].NonDerogableRights(SectionTitle);
GO

/* END */


/* ScheduleSchema */ 

CREATE TABLE [ScheduleSchema].ScheduleOne_NationalFlag
(
	SectionID int PRIMARY KEY,
	SectionText nvarchar(300) NOT NULL
);
GO

CREATE TABLE [ScheduleSchema].ScheduleOneA_GeoAreasProvinces
(
	ProvinceID int identity PRIMARY KEY,
	Province varchar(45) NOT NULL,
	MapCSV nvarchar(MAX) NOT NULL
);
GO

CREATE TABLE [ScheduleSchema].ScheduleTwo_OathsAffirmations
(
	SectionID int PRIMARY KEY,
	SectionTitle nvarchar(200) NOT NULL,
	SectionText nvarchar(MAX)
)
GO

CREATE TABLE [ScheduleSchema].ScheduleTwo_Subsections
(
	SubsectionID nvarchar(5),
    SectionID int FOREIGN KEY REFERENCES [ScheduleSchema].ScheduleTwo_OathsAffirmations(SectionID),
    SubsectionText nvarchar(MAX) NOT NULL
	PRIMARY KEY(SectionID, SubsectionID)
)
GO

CREATE TABLE [ScheduleSchema].ScheduleThree_Parts
(
	PartID char(1) PRIMARY KEY,
	PartName nvarchar(110) NOT NULL
)
GO
CREATE TABLE [ScheduleSchema].ScheduleThree_ElectionProcedures
(
	SectionID int,
	SectionThreePart char(1) NOT NULL FOREIGN KEY REFERENCES [ScheduleSchema].ScheduleThree_Parts(PartID),
	SectionTitle nvarchar(100) NOT NULL,
	SectionText nvarchar(MAX),
	PRIMARY KEY(SectionID, SectionThreePart)
)
GO
CREATE TABLE [ScheduleSchema].ScheduleThree_Subsections
(
	SubsectionID nvarchar(3),
	SectionID int,
	SectionThreePart char(1) NOT NULL,
	SectionText nvarchar(MAX),
	PRIMARY KEY(SectionID, SectionThreePart, SubsectionID),
	FOREIGN KEY (SectionID, SectionThreePart) REFERENCES [ScheduleSchema].ScheduleThree_ElectionProcedures(SectionID, SectionThreePart)
)
GO

CREATE TABLE [ScheduleSchema].ScheduleFour_ConcurrentCompetencies
(
	PartID char(1) PRIMARY KEY,
	PartCSV nvarchar(MAX) NOT NULL
)
GO

CREATE TABLE [ScheduleSchema].ScheduleFive_ExclusiveProvincialCompetencies
(
	PartID char(1) PRIMARY KEY,
	PartCSV nvarchar(MAX) NOT NULL
)
GO

CREATE TABLE [ScheduleSchema].ScheduleSix_TransitionalArrangements
(
	SectionID int PRIMARY KEY,
	SectionTitle nvarchar(MAX) NOT NULL,
	SectionText nvarchar(MAX)
)
GO
CREATE TABLE [ScheduleSchema].ScheduleSix_Subsections
(
	SubsectionID nvarchar(3),
    SectionID int FOREIGN KEY REFERENCES [ScheduleSchema].ScheduleSix_TransitionalArrangements(SectionID),
    SubsectionText nvarchar(MAX) NOT NULL
	PRIMARY KEY(SectionID, SubsectionID)
)
GO
CREATE TABLE [ScheduleSchema].ScheduleSix_Clauses
(
    ClauseID nvarchar(3),
    SectionID int,
    SubsectionID nvarchar(3),
    ClauseText nvarchar(MAX) NOT NULL,
    PRIMARY KEY(ClauseID, SectionID, SubsectionID),
    FOREIGN KEY (SectionID, SubsectionID) REFERENCES [ScheduleSchema].ScheduleSix_Subsections(SectionID, SubsectionID)
)
GO

CREATE TABLE [ScheduleSchema].ScheduleSeven_RepealedLaws
(
	ActNum nvarchar(20) PRIMARY KEY,
	Title nvarchar(80) NOT NULL
)
GO

CREATE TABLE [ScheduleSchema].Annexures
(
	AnnexureID char(1) PRIMARY KEY,
	AnnexureTitle nvarchar(MAX) NOT NULL
);
CREATE TABLE [ScheduleSchema].AnnexureContents
(
	SectionID int,
	AnnexureID char(1) NOT NULL FOREIGN KEY REFERENCES [ScheduleSchema].Annexures(AnnexureID),
	SectionTitle nvarchar(MAX) NOT NULL,
	SectionText nvarchar(MAX),
	PRIMARY KEY(SectionID, AnnexureID)
)
GO
CREATE TABLE [ScheduleSchema].AnnexureSubsections
(
	SubsectionID nvarchar(3),
	SectionID int,
	AnnexureID char(1) NOT NULL FOREIGN KEY REFERENCES [ScheduleSchema].Annexures(AnnexureID),
	SectionText nvarchar(MAX),
	PRIMARY KEY(SectionID, AnnexureID, SubsectionID),
	FOREIGN KEY (SectionID, AnnexureID) REFERENCES [ScheduleSchema].AnnexureContents(SectionID, AnnexureID)
)
GO

/* END */


/*
	////////////////////
	Insert Statements to fill tables with needed content
	///////////////////
*/

/* 
	//////////////// 
	MainSchema 
	/////////////// 
*/

/* /////////////// Chapters /////////// */
INSERT INTO [MainSchema].Chapters
VALUES
(0, 'Preamble'),
(1, 'Founding Provisions'),
(2, 'Bill of Rights'),
(3, 'Co-operative Government'),
(4, 'Parliament'),
(5, 'The President and National Executive'),
(6, 'Provinces'),
(7, 'Local Government'),
(8, 'Courts and Administration of Justice'),
(9, 'State Institutions Supporting Constitutional Democracy'),
(10, 'Public Administration'),
(11, 'Security Services'),
(12, 'Traditional Leaders'),
(13, 'Finance'),
(14, 'General Provisions');
GO

/* /////////////// Chapter 1's contents /////////// */
INSERT INTO [MainSchema].Sections (SectionID, ChapterID, SectionTitle, SectionText)
VALUES
(0, 0, 'Preamble', 'We, the people of South Africa, Recognise the injustices of our past; Honour those who suffered for justice and freedom in our land; Respect those who have worked to build and develop our country; and Believe that South Africa belongs to all who live in it, united in our diversity. We therefore, through our freely elected representatives, adopt this Constitution as the supreme law of the Republic so as to - Heal the divisions of the past and establish a society based on democratic values, social justice and fundamental human rights; Lay the foundations for a democratic and open society in which government is based on the will of the people and every citizen is equally protected by law; Improve the quality of life of all citizens and free the potential of each person; and Build a united and democratic South Africa able to take its rightful place as a sovereign state in the family of nations. May God protect our people. Nkosi Sikelel'' iAfrika. Morena boloka setjhaba sa heso. God seën Suid-Afrika. God bless South Africa. Mudzimu fhatutshedza Afurika. Hosi katekisa Afrika.'),
(1, 1, 'Republic of South Africa', NULL),
(2, 1, 'Supremacy of Constitution', 'This Constitution is the supreme law of the Republic; law or conduct inconsistent with it is invalid, and the obligations imposed by it must be fulfilled.'),
(3, 1, 'Citizenship', NULL),
(4, 1, 'National anthem', 'The national anthem of the Republic is determined by the President by proclamation'),
(5, 1, 'National flag', 'The national flag of the Republic is black, gold, green, white, red, and blue, as described and sketched in Schedule 1.'),
(6, 1, 'Languages', NULL);

INSERT INTO [MainSchema].Subsections (SubsectionID, SectionID, SubsectionText)
VALUES
('0', 1, 'The Republic of South Africa is one, sovereign, democratic state founded on the following values:'),
('0a', 1, 'Human dignity, the achievement of equality and the advancement of human rights and freedoms.'),
('0b', 1, 'Non-racialism and non-sexism.'),
('0c', 1, 'Supremacy of the constitution and the rule of law.'),
('0d', 1, 'Universal adult suffrage, a national common voters roll, regular elections and a multi-party system of democratic government, to ensure accountability, responsiveness and openness.'),

('1', 3, 'There is a common South African citizenship.'),
('2', 3, 'All citizens are──'),
('2a', 3, 'equally entitled to the rights, privileges and benefits of citizenship; and'),
('2b', 3, 'equally subject to the duties and responsibilities of citizenship.'),
('3', 3, 'National legislation must provide for the acquisition, loss and restoration of citizenship.'),

('1', 6, 'The official languages of the Republic are Sepedi, Sesotho, Setswana, siSwati, Tshivenda, Xitsonga, Afrikaans, South African Sign Language, English, isiNdebele, isiXhosa and isiZulu.'),
('2', 6, 'Recognising the historically diminished use and status of the indigenous languages of our people, the state must take practical and positive measures to elevate the
status and advance the use of these languages.'),
('3a', 6, 'The national government and provincial governments may use any particular
official languages for the purposes of government, taking into account usage,
practicality, expense, regional circumstances and the balance of the needs and
preferences of the population as a whole or in the province concerned; but the
national government and each provincial government must use at least two
official languages.'),
('3b', 6, 'Municipalities must take into account the language usage and preferences of their residents.'),
('4', 6, 'The national government and provincial governments, by legislative and other
measures, must regulate and monitor their use of official languages. Without
detracting from the provisions of subsection (2), all official languages must enjoy
parity of esteem and must be treated equitably'),
('5', 6, 'A Pan South African Language Board established by national legislation must──'),
('5a', 6, 'promote, and create conditions for, the development and use of──'),
('5b', 6, 'promote and ensure respect for──');

INSERT INTO [MainSchema].Clauses (ClauseID, SectionID, SubsectionID, ClauseText)
VALUES
('i', 6, '5a' ,'all official languages;'),
('ii', 6, '5a' ,'the Khoi, Nama and San languages; and'),
('iii', 6, '5a' ,'sign language; and'),
('i', 6, '5b' ,'all languages commonly used by communities in South Africa, including German, Greek, Gujarati, Hindi,
Portuguese, Tamil, Telugu and Urdu; and'),
('ii', 6, '5b' ,'Arabic, Hebrew, Sanskrit and other languages used for religious purposes in South Africa.');

GO


/* /////////////// Chapter 2's contents /////////// */
INSERT INTO [MainSchema].Sections (SectionID, ChapterID, SectionTitle, SectionText)
VALUES
(7, 2, 'Rights', NULL),
(10, 2, 'Human dignity', 'Everyone has inherent dignity and the right to have their dignity respected and protected.'),
(11, 2, 'Life', 'Everyone has the right to life.'),
(13, 2, 'Slavery, servitude and forced labour', 'No one may be subjected to slavery, servitude or forced labour.'),
(14, 2, 'Privacy', NULL),
(17, 2, 'Assembly, demonstration, picket and petition', 'Everyone has the right, peacefully and unarmed, to assemble, to demonstrate, to picket and to present petitions.'),
(18, 2, 'Freedom of association', 'Everyone has the right to freedom of association.'),
(20, 2, 'Citizenship', 'No citizen may be deprived of citizenship.'),
(21, 2, 'Freedom of movement and residence', NULL),
(22, 2, 'Freedom of trade, occupation and profession', 'Every citizen has the right to choose their trade, occupation or profession freely. The practice of a trade, occupation or profession may be regulated by law.'),
(24, 2, 'Environment', NULL),
(30, 2, 'Language and culture', 'Everyone has the right to use the language and to participate in the cultural life of their choice, but no one exercising these rights may do so in a manner inconsistent with any provision of the Bill of Rights.'),
(32, 2, 'Access to information', NULL),
(34, 2, 'Access to courts', 'Everyone has the right to have any dispute that can be resolved by the application of law decided in a fair public hearing before a court or, where appropriate, another independent and impartial tribunal or forum.'),
(8, 2, 'Application', NULL),
(9, 2, 'Equality', NULL),
(12, 2, 'Freedom and security of the person', NULL),
(15, 2, 'Freedom of religion, belief and opinion', NULL),
(16, 2, 'Freedom of expression', NULL),
(19, 2, 'Political rights', NULL),
(23, 2, 'Labour relations', NULL),
(25, 2, 'Property', NULL),
(26, 2, 'Housing', NULL),
(27, 2, 'Health care, food, water and social security', NULL),
(28, 2, 'Children', NULL),
(29, 2, 'Education', NULL),
(31, 2, 'Cultural, religious and linguistic communities', NULL),
(33, 2, 'Just administrative action', NULL),
(35, 2, 'Arrested, detained and accused persons', NULL),
(36, 2, 'Limitation of rights', NULL),
(37, 2, 'States of emergency', NULL),
(38, 2, 'Enforcement of rights', NULL),
(39, 2, 'Interpretation of Bill of Rights', NULL);

INSERT INTO [MainSchema].Subsections (SubsectionID, SectionID, SubsectionText)
VALUES
('1', 7, 'This Bill of Rights is a cornerstone of democracy in South Africa. It enshrines the
rights of all people in our country and affirms the democratic values of human
dignity, equality and freedom.'),
('2', 7, 'The state must respect, protect, promote and fulfil the rights in the Bill of Rights.'),
('3', 7, 'The rights in the Bill of Rights are subject to the limitations contained or referred to in section 36, or elsewhere
in the Bill.'),

('1' , 8, 'The Bill of Rights applies to all law, and binds the legislature, the executive, the
judiciary and all organs of state.'),
('2' , 8, 'A provision of the Bill of Rights binds a natural or a juristic person if, and to the
extent that, it is applicable, taking into account the nature of the right and the
nature of any duty imposed by the right.'),
('3' , 8, 'When applying a provision of the Bill of Rights to a natural or juristic person in terms
of subsection (2), a court—'),
('3a' , 8, 'in order to give effect to a right in the Bill, must apply, or if necessary develop,
the common law to the extent that legislation does not give effect to that
right; and'),
('3b' , 8, 'may develop rules of the common law to limit the right, provided that the
limitation is in accordance with section 36(1).'),
('4' , 8, 'A juristic person is entitled to the rights in the Bill of Rights to the extent required by
the nature of the rights and the nature of that juristic person.'),

('1' , 9, 'Everyone is equal before the law and has the right to equal protection and benefit of
the law.'),
('2' , 9, 'Equality includes the full and equal enjoyment of all rights and freedoms. To
promote the achievement of equality, legislative and other measures designed
to protect or advance persons, or categories of persons, disadvantaged by unfair
discrimination may be taken.'),
('3' , 9, 'The state may not unfairly discriminate directly or indirectly against anyone on one
or more grounds, including race, gender, sex, pregnancy, marital status, ethnic or
social origin, colour, sexual orientation, age, disability, religion, conscience, belief,
culture, language and birth.'),
('4' , 9, 'No person may unfairly discriminate directly or indirectly against anyone on one or
more grounds in terms of subsection (3). National legislation must be enacted to
prevent or prohibit unfair discrimination.'),
('5' , 9, 'Discrimination on one or more of the grounds listed in subsection (3) is unfair unless
it is established that the discrimination is fair.'),

('1', 12, 'Everyone has the right to freedom and security of the person, which includes the
right—'),
('1a', 12, 'not to be deprived of freedom arbitrarily or without just cause;'),
('1b', 12, 'not to be detained without trial;'),
('1c', 12, 'to be free from all forms of violence from either public or private sources;'),
('1d', 12, 'not to be tortured in any way; and'),
('1e', 12, 'not to be treated or punished in a cruel, inhuman or degrading way.'),
('2', 12, 'Everyone has the right to bodily and psychological integrity, which includes the
right—'),
('2a', 12, 'to make decisions concerning reproduction;'),
('2b', 12, 'to security in and control over their body; and'),
('2c', 12, 'not to be subjected to medical or scientific experiments without their informed
consent.'),

('0', 14, 'Everyone has the right to privacy, which includes the right not to have—'),
('0a', 14, 'their person or home searched;'),
('0b', 14, 'their property searched;'),
('0c', 14, 'their possessions seized; or'),
('0d', 14, 'the privacy of their communications infringed.'),

('1', 15, 'Everyone has the right to freedom of conscience, religion, thought, belief and
opinion.'),
('2', 15, 'Religious observances may be conducted at state or state-aided institutions,
provided that—'),
('2a', 15, 'those observances follow rules made by the appropriate public authorities;'),
('2b', 15, 'they are conducted on an equitable basis; and'),
('2c', 15, 'attendance at them is free and voluntary.'),
('3a', 15, 'This section does not prevent legislation recognising—'),
('3b', 15, 'Recognition in terms of paragraph (a) must be consistent with this section and
the other provisions of the Constitution.'),

('1', 16, 'Everyone has the right to freedom of expression, which includes—'),
('1a', 16, 'freedom of the press and other media;'),
('1b', 16, 'freedom to receive or impart information or ideas;'),
('1c', 16, 'freedom of artistic creativity; and'),
('1d', 16, 'academic freedom and freedom of scientific research.'),
('2', 16, 'The right in subsection (1) does not extend to—'),
('2a', 16, 'propaganda for war;'),
('2b', 16, 'incitement of imminent violence; or'),
('2c', 16, 'advocacy of hatred that is based on race, ethnicity, gender or religion, and that
constitutes incitement to cause harm.'),

('1', 19, 'Every citizen is free to make political choices, which includes the right—'),
('1a', 19, 'to form a political party;'),
('1b', 19, 'to participate in the activities of, or recruit members for, a political party; and'),
('1c', 19, 'to campaign for a political party or cause.'),
('2', 19, 'Every citizen has the right to free, fair and regular elections for any legislative body
established in terms of the Constitution.'),
('3', 19, 'Every adult citizen has the right—'),
('3a', 19, 'to vote in elections for any legislative body established in terms of the
Constitution, and to do so in secret; and'),
('3b', 19, 'to stand for public office and, if elected, to hold office.'),


('1', 21, 'Everyone has the right to freedom of movement.'),
('2', 21, 'Everyone has the right to leave the Republic.'),
('3', 21, 'Every citizen has the right to enter, to remain in and to reside anywhere in, the
Republic.'),
('4', 21, 'Every citizen has the right to a passport.'),

('1', 23, 'Everyone has the right to fair labour practices.'),
('2', 23, 'Every worker has the right—'),
('2a', 23, 'to form and join a trade union'),
('2b', 23, 'to participate in the activities and programmes of a trade union; and'),
('2c', 23, 'to strike'),
('3', 23, 'Every employer has the right—'),
('3a', 23, 'to form and join an employers'' organisation; and'),
('3b', 23, 'to participate in the activities and programmes of an employers'' organisation.'),
('4', 23, 'Every trade union and every employers’ organisation has the right—'),
('4a', 23, 'to determine its own administration, programmes and activities;'),
('4b', 23, 'to organise; and'),
('4c', 23, 'to form and join a federation.'),
('5', 23, 'Every trade union, employers’ organisation and employer has the right to engage
in collective bargaining. National legislation may be enacted to regulate collective
bargaining. To the extent that the legislation may limit a right in this Chapter, the
limitation must comply with section 36(1).'),
('6', 23, 'National legislation may recognise union security arrangements contained in
collective agreements. To the extent that the legislation may limit a right in this
Chapter, the limitation must comply with section 36(1).'),

('0', 24, 'Everyone has the right—'),
('0a', 24, 'to an environment that is not harmful to their health or wellbeing; and'),
('0b', 24, 'to have the environment protected, for the benefit of present and future
generations, through reasonable legislative and other measures that—'),

('1', 25, 'No one may be deprived of property except in terms of law of general application,
and no law may permit arbitrary deprivation of property.'),
('2', 25, 'Property may be expropriated only in terms of law of general application—'),
('2a', 25, 'for a public purpose or in the public interest; and'),
('2b', 25, 'subject to compensation, the amount of which and the time and manner of
payment of which have either been agreed to by those affected or decided or
approved by a court.'),
('3', 25, 'The amount of the compensation and the time and manner of payment must be just
and equitable, reflecting an equitable balance between the public interest and the
interests of those affected, having regard to all relevant circumstances, including—'),
('3a', 25, 'the current use of the property;'),
('3b', 25, 'the history of the acquisition and use of the property;'),
('3c', 25, 'the market value of the property;'),
('3d', 25, 'the extent of direct state investment and subsidy in the acquisition and
beneficial capital improvement of the property; and'),
('3e', 25, 'the purpose of the expropriation.'),
('4', 25, 'For the purposes of this section—'),
('4a', 25, 'the public interest includes the nation’s commitment to land reform, and to
reforms to bring about equitable access to all South Africa’s natural resources;
and'),
('4b', 25, 'property is not limited to land.'),
('5', 25, 'The state must take reasonable legislative and other measures, within its available
resources, to foster conditions which enable citizens to gain access to land on an
equitable basis.'),
('6', 25, 'A person or community whose tenure of land is legally insecure as a result of past
racially discriminatory laws or practices is entitled, to the extent provided by an Act
of Parliament, either to tenure which is legally secure or to comparable redress.'),
('7', 25, 'A person or community dispossessed of property after 19 June 1913 as a result of
past racially discriminatory laws or practices is entitled, to the extent provided by an
Act of Parliament, either to restitution of that property or to equitable redress.'),
('8', 25, 'No provision of this section may impede the state from taking legislative and other
measures to achieve land, water and related reform, in order to redress the results
of past racial discrimination, provided that any departure from the provisions of this
section is in accordance with the provisions of section 36(1).'),
('9', 25, 'Parliament must enact the legislation referred to in subsection (6).'),


('1', 26, 'Everyone has the right to have access to adequate housing.'),
('2', 26, 'The state must take reasonable legislative and other measures, within its available
resources, to achieve the progressive realisation of this right.'),
('3', 26, 'No one may be evicted from their home, or have their home demolished, without an
order of court made after considering all the relevant circumstances. No legislation
may permit arbitrary evictions.'),

('1', 27, 'Everyone has the right to have access to—'),
('1a', 27, 'health care services, including reproductive health care;'),
('1b', 27, 'sufficient food and water; and'),
('1c', 27, 'social security, including, if they are unable to support themselves and their
dependants, appropriate social assistance.'),
('2', 27, 'The state must take reasonable legislative and other measures, within its available
resources, to achieve the progressive realisation of each of these rights.'),
('3', 27, 'No one may be refused emergency medical treatment.'),

('1', 28, 'Every child has the right—'),
('1a', 28, 'to a name and a nationality from birth;'),
('1b', 28, 'to family care or parental care, or to appropriate alternative care when
removed from the family environment;'),
('1c', 28, 'to basic nutrition, shelter, basic health care services and social services;'),
('1d', 28, 'to be protected from maltreatment, neglect, abuse or degradation;'),
('1e', 28, 'to be protected from exploitative labour practices;'),
('1f', 28, 'not to be required or permitted to perform work or provide services that—'),
('1g', 28, 'not to be detained except as a measure of last resort, in which case, in addition
to the rights a child enjoys under sections 12 and 35, the child may be detained
only for the shortest appropriate period of time, and has the right to be—'),
('1h', 28, 'to have a legal practitioner assigned to the child by the state, and at state
expense, in civil proceedings affecting the child, if substantial injustice would
otherwise result; and'),
('1i', 28, 'not to be used directly in armed conflict, and to be protected in times of armed
conflict.'),
('2', 28, 'A child’s best interests are of paramount importance in every matter concerning the
child.'),
('3', 28, 'In this section “child” means a person under the age of 18 years.'),

('1', 29, 'Everyone has the right—'),
('1a', 29, 'to a basic education, including adult basic education; and'),
('1b', 29, 'to further education, which the state, through reasonable measures, must
make progressively available and accessible.'),
('2', 29, 'Everyone has the right to receive education in the official language or languages of
their choice in public educational institutions where that education is reasonably
practicable. In order to ensure the effective access to, and implementation of, this
right, the state must consider all reasonable educational alternatives, including
single medium institutions, taking into account—'),
('2a', 29, 'equity;'),
('2b', 29, 'practicability; and'),
('2c', 29, 'the need to redress the results of past racially discriminatory laws and
practices.'),
('3', 29, 'Everyone has the right to establish and maintain, at their own expense,
independent educational institutions that—'),
('3a', 29, 'do not discriminate on the basis of race;'),
('3b', 29, 'are registered with the state; and'),
('3c', 29, 'maintain standards that are not inferior to standards at comparable public
educational institutions.'),
('4', 29, 'Subsection (3) does not preclude state subsidies for independent educational
institutions.'),

('1', 31, 'Persons belonging to a cultural, religious or linguistic community may not be denied
the right, with other members of that community—'),
('1a', 31, 'to enjoy their culture, practise their religion and use their language; and'),
('1b', 31, 'to form, join and maintain cultural, religious and linguistic associations and
other organs of civil society.'),
('2', 31, 'The rights in subsection (1) may not be exercised in a manner inconsistent with any
provision of the Bill of Rights.'),

('1', 32, 'Everyone has the right of access to—'),
('1a', 32, 'any information held by the state; and'),
('1b', 32, 'any information that is held by another person and that is required for the
exercise or protection of any rights.'),
('2', 32, 'National legislation must be enacted to give effect to this right, and may provide
for reasonable measures to alleviate the administrative and financial burden on the
state.'),

('1', 33, 'Everyone has the right to administrative action that is lawful, reasonable and
procedurally fair.'),
('2', 33, 'Everyone whose rights have been adversely affected by administrative action has
the right to be given written reasons.'),
('3', 33, 'National legislation must be enacted to give effect to these rights, and must—'),
('3a', 33, 'provide for the review of administrative action by a court or, where
appropriate, an independent and impartial tribunal;'),
('3b', 33, 'impose a duty on the state to give effect to the rights in subsections (1) and
(2); and'),
('3c', 33, 'promote an efficient administration.'),

('1', 35, 'Everyone who is arrested for allegedly committing an offence has the right—'),
('1a', 35, 'to remain silent;'),
('1b', 35, 'to be informed promptly—'),
('1c', 35, 'not to be compelled to make any confession or admission that could be used in
evidence against that person;'),
('1d', 35, 'to be brought before a court as soon as reasonably possible, but not later
than—'),
('1e', 35, 'at the first court appearance after being arrested, to be charged or to be
informed of the reason for the detention to continue, or to be released; and'),
('1f', 35, 'to be released from detention if the interests of justice permit, subject to
reasonable conditions.'),
('2', 35, 'Everyone who is detained, including every sentenced prisoner, has the right—'),
('2a', 35, 'to be informed promptly of the reason for being detained;'),
('2b', 35, 'to choose, and to consult with, a legal practitioner, and to be informed of this
right promptly;'),
('2c', 35, 'to have a legal practitioner assigned to the detained person by the state and
at state expense, if substantial injustice would otherwise result, and to be
informed of this right promptly;'),
('2d', 35, 'to challenge the lawfulness of the detention in person before a court and, if
the detention is unlawful, to be released;'),
('2e', 35, 'to conditions of detention that are consistent with human dignity, including at
least exercise and the provision, at state expense, of adequate accommodation,
nutrition, reading material and medical treatment; and'),
('2f', 35, 'to communicate with, and be visited by, that person’s—'),
('3', 35, 'Every accused person has a right to a fair trial, which includes the right—'),
('3a', 35, 'to be informed of the charge with sufficient detail to answer it;'),
('3b', 35, 'to have adequate time and facilities to prepare a defence;'),
('3c', 35, 'to a public trial before an ordinary court;'),
('3d', 35, 'to have their trial begin and conclude without unreasonable delay;'),
('3e', 35, 'to be present when being tried;'),
('3f', 35, 'to choose, and be represented by, a legal practitioner, and to be informed of
this right promptly;'),
('3g', 35, 'to have a legal practitioner assigned to the accused person by the state and
at state expense, if substantial injustice would otherwise result, and to be
informed of this right promptly;'),
('3h', 35, 'to be presumed innocent, to remain silent, and not to testify during the
proceedings;'),
('3i', 35, 'to adduce and challenge evidence;'),
('3j', 35, 'not to be compelled to give self-incriminating evidence;'),
('3k', 35, 'to be tried in a language that the accused person understands or, if that is not
practicable, to have the proceedings interpreted in that language;'),
('3l', 35, 'not to be convicted for an act or omission that was not an offence under either
national or international law at the time it was committed or omitted;'),
('3m', 35, 'not to be tried for an offence in respect of an act or omission for which that
person has previously been either acquitted or convicted;'),
('3n', 35, 'to the benefit of the least severe of the prescribed punishments if the
prescribed punishment for the offence has been changed between the time
that the offence was committed and the time of sentencing; and'),
('3o', 35, 'of appeal to, or review by, a higher court.'),
('4', 35, 'Whenever this section requires information to be given to a person, that information
must be given in a language that the person understands.'),
('5', 35, 'Evidence obtained in a manner that violates any right in the Bill of Rights must be
excluded if the admission of that evidence would render the trial unfair or otherwise
be detrimental to the administration of justice.'),

('1', 36, 'The rights in the Bill of Rights may be limited only in terms of law of general
application to the extent that the limitation is reasonable and justifiable in an open
and democratic society based on human dignity, equality and freedom, taking into
account all relevant factors, including—'),
('1a', 36, 'the nature of the right;'),
('1b', 36, 'the importance of the purpose of the limitation;'),
('1c', 36, 'the nature and extent of the limitation;'),
('1d', 36, 'the relation between the limitation and its purpose; and'),
('1e', 36, 'less restrictive means to achieve the purpose.'),
('2', 36, 'Except as provided in subsection (1) or in any other provision of the Constitution, no
law may limit any right entrenched in the Bill of Rights.'),

('1', 37, 'A state of emergency may be declared only in terms of an Act of Parliament, and
only when—'),
('1a', 37, 'the life of the nation is threatened by war, invasion, general insurrection,
disorder, natural disaster or other public emergency; and'),
('1b', 37, 'the declaration is necessary to restore peace and order.'),
('2', 37, 'A declaration of a state of emergency, and any legislation enacted or other action
taken in consequence of that declaration, may be effective only—'),
('2a', 37, 'prospectively; and'),
('2b', 37, 'for no more than 21 days from the date of the declaration, unless the National
Assembly resolves to extend the declaration. The Assembly may extend a
declaration of a state of emergency for no more than three months at a time.
The first extension of the state of emergency must be by a resolution adopted
with a supporting vote of a majority of the members of the Assembly. Any
subsequent extension must be by a resolution adopted with a supporting
vote of at least 60 per cent of the members of the Assembly. A resolution in
terms of this paragraph may be adopted only following a public debate in the
Assembly.'),
('3', 37, 'Any competent court may decide on the validity of—'),
('3a', 37, 'a declaration of a state of emergency;'),
('3b', 37, 'any extension of a declaration of a state of emergency; or'),
('3c', 37, 'any legislation enacted, or other action taken, in consequence of a declaration
of a state of emergency.'),
('4', 37, 'Any legislation enacted in consequence of a declaration of a state of emergency may
derogate from the Bill of Rights only to the extent that—'),
('4a', 37, 'the derogation is strictly required by the emergency; and'),
('4b', 37, 'the legislation—'),
('5', 37, 'No Act of Parliament that authorises a declaration of a state of emergency, and
no legislation enacted or other action taken in consequence of a declaration, may
permit or authorise—'),
('5a', 37, 'indemnifying the state, or any person, in respect of any unlawful act;'),
('5b', 37, 'any derogation from this section; or'),
('5c', 37, 'any derogation from a section mentioned in column 1 of the Table of Non-
Derogable Rights, to the extent indicated opposite that section in column 3 of
the Table.'),
('6', 37, 'Whenever anyone is detained without trial in consequence of a derogation of rights
resulting from a declaration of a state of emergency, the following conditions must
be observed:'),
('6a', 37, 'An adult family member or friend of the detainee must be contacted as soon as
reasonably possible, and informed that the person has been detained.'),
('6b', 37, 'A notice must be published in the national Government Gazette within five
days of the person being detained, stating the detainee’s name and place of
detention and referring to the emergency measure in terms of which that
person has been detained.'),
('6c', 37, 'The detainee must be allowed to choose, and be visited at any reasonable time
by, a medical practitioner.'),
('6d', 37, 'The detainee must be allowed to choose, and be visited at any reasonable time
by, a legal representative.'),
('6e', 37, 'A court must review the detention as soon as reasonably possible, but no
later than 10 days after the date the person was detained, and the court must
release the detainee unless it is necessary to continue the detention to restore
peace and order.'),
('6f', 37, 'A detainee who is not released in terms of a review under paragraph (e), or
who is not released in terms of a review under this paragraph, may apply to
a court for a further review of the detention at any time after 10 days have
passed since the previous review, and the court must release the detainee
unless it is still necessary to continue the detention to restore peace and order.'),
('6g', 37, 'The detainee must be allowed to appear in person before any court considering
the detention, to be represented by a legal practitioner at those hearings, and
to make representations against continued detention.'),
('6h', 37, 'The state must present written reasons to the court to justify the continued
detention of the detainee, and must give a copy of those reasons to the
detainee at least two days before the court reviews the detention.'),
('7', 37, 'If a court releases a detainee, that person may not be detained again on the same
grounds unless the state first shows a court good cause for re-detaining that person.'),
('8', 37, 'Subsections (6) and (7) do not apply to persons who are not South African
citizens and who are detained in consequence of an international armed conflict.
Instead, the state must comply with the standards binding on the Republic under
international humanitarian law in respect of the detention of such persons.'),

('0', 38, 'Anyone listed in this section has the right to approach a competent court, alleging that
a right in the Bill of Rights has been infringed or threatened, and the court may grant
appropriate relief, including a declaration of rights. The persons who may approach a court
are—'),
('0a', 38, 'anyone acting in their own interest;'),
('0b', 38, 'anyone acting on behalf of another person who cannot act in their own name;'),
('0c', 38, 'anyone acting as a member of, or in the interest of, a group or class of persons;'),
('0d', 38, 'anyone acting in the public interest; and'),
('0e', 38, 'an association acting in the interest of its members.'),

('1', 39, 'When interpreting the Bill of Rights, a court, tribunal or forum—'),
('1a', 39, 'must promote the values that underlie an open and democratic society based
on human dignity, equality and freedom;'),
('1b', 39, 'must consider international law; and'),
('1c', 39, 'may consider foreign law.'),
('2', 39, 'When interpreting any legislation, and when developing the common law or
customary law, every court, tribunal or forum must promote the spirit, purport and
objects of the Bill of Rights.'),
('3', 39, 'The Bill of Rights does not deny the existence of any other rights or freedoms that
are recognised or conferred by common law, customary law or legislation, to the
extent that they are consistent with the Bill.');

GO

INSERT INTO [MainSchema].NonDerogableRights (SectionNumber, SectionTitle, ProtectionExtent)
VALUES
(9, 'Equality', 'With respect to unfair discrimination solely on the grounds of race, colour, ethnic or social origin, sex, religion or language.'),
(10, 'Human Dignity', 'Entirely'),
(11, 'Life', 'Entirely'),
(12, 'Freedom and Security of the person', 'With respect to subsections (1)(d) and (e) and (2)(c).'),
(13, 'Slavery, servitude and forced labour', 'With respect to slavery and servitude'),
(28, 'Children', 'With respect to: 
- subsection (1)(d) and (e); 
- the rights in subparagraphs (i) and (ii) of subsection (1)(g); and 
- subsection 1(i) in respect of children of 15 years and younger.'),
(35, 'Arrested, detained and accused persons', 'With respect to:
- subsections (1)(a), (b) and (c) and (2)(d);
- the rights in paragraphs (a) to (o) of subsection (3), excluding paragraph (d);
- subsection (4); and
- subsection (5) with respect to the exclusion of evidence if the admission would render the trial unfair.');


INSERT INTO [MainSchema].Clauses (ClauseID, SectionID, SubsectionID, ClauseText)
VALUES
('i', 15, '3a' ,'marriages concluded under any tradition, or a system of religious, personal or family law; or'),
('ii', 15, '3a' ,'systems of personal and family law under any tradition, or adhered to by persons professing a particular religion'),

('i', 24, '0b' ,'prevent pollution and ecological degradation;'),
('ii', 24, '0b' ,'promote conservation;and'),
('iii', 24, '0b' ,'secure ecologically sustainable development and use of natural resources
while promoting justifiable economic and social development.'),

('i', 28, '1f' ,'are inappropriate for a person of that child’s age; or'),
('ii', 28, '1f' ,'place at risk the child’s well-being, education, physical or mental health
or spiritual, moral or social development;'),
('i', 28, '1g' ,'kept separately from detained persons over the age of 18 years; and'),
('ii', 28, '1g' ,'treated in a manner, and kept in conditions, that take account of the
child’s age;'),

('i', 35, '1b' ,'of the right to remain silent; and'),
('ii', 35, '1b' ,'of the consequences of not remaining silent;'),
('i', 35, '1d' ,'48 hours after the arrest; or'),
('ii', 35, '1d' ,'the end of the first court day after the expiry of the 48 hours, if the 48
hours expire outside ordinary court hours or on a day which is not an
ordinary court day;'),
('i', 35, '2f' ,'spouse or partner;'),
('ii', 35, '2f' ,'next of kin;'),
('iii', 35, '2f' ,'chosen religious counsellor; and'),
('iv', 35, '2f' ,'chosen medical practitioner.'),

('i', 37, '4b' ,'is consistent with the Republic’s obligations under international law
applicable to states of emergency;'),
('ii', 37, '4b' ,'conforms to subsection (5); and'),
('iii', 37, '4b' ,'is published in the national Government Gazette as soon as reasonably
possible after being enacted.');

GO


/* /////////////// Chapter 3's contents /////////// */
INSERT INTO [MainSchema].Sections (SectionID, ChapterID, SectionTitle, SectionText)
VALUES
(40, 3, 'Government of the Republic', NULL),
(41, 3, 'Principles of co-operative government and intergovernmental relations', NULL);


INSERT INTO [MainSchema].Subsections (SubsectionID, SectionID, SubsectionText)
VALUES
('1', 40, 'In the Republic, government is constituted as national, provincial and local spheres
of government which are distinctive, interdependent and interrelated.'),
('2', 40, 'All spheres of government must observe and adhere to the principles in this Chapter
and must conduct their activities within the parameters that the Chapter provides.'),

('1', 41, 'All spheres of government and all organs of state within each sphere must—'),
('1a', 41, 'preserve the peace, national unity and the indivisibility of the Republic;'),
('1b', 41, 'secure the well-being of the people of the Republic;'),
('1c', 41, 'provide effective, transparent, accountable and coherent government for the
Republic as a whole;'),
('1d', 41, 'be loyal to the Constitution, the Republic and its people;'),
('1e', 41, 'respect the constitutional status, institutions, powers and functions of
government in the other spheres;'),
('1f', 41, 'not assume any power or function except those conferred on them in terms of
the Constitution;'),
('1g', 41, 'exercise their powers and perform their functions in a manner that does
not encroach on the geographical, functional or institutional integrity of
government in another sphere; and'),
('1h', 41, 'co-operate with one another in mutual trust and good faith by—'),
('2', 41, 'An Act of Parliament must—'),
('2a', 41, 'establish or provide for structures and institutions to promote and facilitate
intergovernmental relations; and'),
('2b', 41, 'provide for appropriate mechanisms and procedures to facilitate settlement of
intergovernmental disputes.'),
('3', 41, 'An organ of state involved in an intergovernmental dispute must make every
reasonable effort to settle the dispute by means of mechanisms and procedures
provided for that purpose, and must exhaust all other remedies before it approaches
a court to resolve the dispute.'),
('4', 41, 'If a court is not satisfied that the requirements of subsection (3) have been met, it
may refer a dispute back to the organs of state involved.');


INSERT INTO [MainSchema].Clauses (ClauseID, SectionID, SubsectionID, ClauseText)
VALUES
('i', 41, '1h' ,'fostering friendly relations;'),
('ii', 41, '1h' ,'assisting and supporting one another;'),
('iii', 41, '1h' ,'informing one another of, and consulting one another on, matters of
common interest;'),
('iv', 41, '1h' ,'co-ordinating their actions and legislation with one another;'),
('v', 41, '1h' ,'adhering to agreed procedures; and'),
('vi', 41, '1h' ,'avoiding legal proceedings against one another.');

GO


/* /////////////// Chapter 4's contents /////////// */
INSERT INTO [MainSchema].Sections (SectionID, ChapterID, SectionTitle, SectionText)
VALUES
(42, 4, 'Composition of Parliament', NULL),
(43, 4, 'Legislative authority of the Republic', NULL),
(44, 4, 'National legislative authority', NULL),
(45, 4, 'Joint rules and orders and joint committees', NULL),
(46, 4, 'Composition and election', NULL),
(47, 4, 'Membership', NULL),
(48, 4, 'Oath or affirmation', 'Before members of the National Assembly begin to perform their functions in the Assembly, they must swear or affirm faithfulness to the Republic and obedience to the Constitution, in accordance with Schedule 2.'),
(49, 4, 'Duration of National Assembly', NULL),
(50, 4, 'Dissolution of National Assembly before expiry of its term', NULL),
(51, 4, 'Sittings and recess periods', NULL),
(52, 4, 'Speaker and Deputy Speaker', NULL),
(53, 4, 'Decisions', NULL),
(54, 4, 'Rights of certain Cabinet members and Deputy Ministers in the National Assembly', 'The President and any member of the Cabinet or any Deputy Minister who is not a member of the National Assembly may, subject to the rules and orders of the Assembly, attend and speak in the Assembly, but may vote.'),
(55, 4, 'Powers of National Assembly', NULL),
(56, 4, 'Evidence or information before National Assembly', NULL),
(57, 4, 'Internal arrangements, proceedings and procedures of National Assembly', NULL),
(58, 4, 'Privilege', NULL),
(59, 4, 'Public access to and involvement in National Assembly', NULL),
(60, 4, 'Composition of National Council', NULL),
(61, 4, 'Allocation of delegates', NULL),
(62, 4, 'Permanent delegates', NULL),
(63, 4, 'Sittings of National Council', NULL),
(64, 4, 'Chairperson and Deputy Chairpersons', NULL),
(65, 4, 'Decisions', NULL),
(66, 4, 'Participation by members of national executive', NULL),
(67, 4, 'Participation by local government representatives', 'Not more than ten part-time representatives designated by organised local government in terms of section 163, to represent the different categories of municipalities, may participate when necessary in the proceedings of the National Council of Provinces, but may not vote.'),
(68, 4, 'Powers of National Council', NULL),
(69, 4, 'Evidence or information before National Council', NULL),
(70, 4, 'Internal arrangements, proceedings and procedures of National Council', NULL),
(71, 4, 'Privilege', NULL),
(72, 4, 'Public access to and involvement in National Council', NULL),
(73, 4, 'All Bills', NULL),
(74, 4, 'Bills amending the Constitution', NULL),
(75, 4, 'Ordinary Bills not affecting provinces', NULL),
(76, 4, 'Ordinary Bills affecting provinces', NULL),
(77, 4, 'Money Bills', NULL),
(78, 4, 'Mediation Committee', NULL),
(79, 4, 'Assent to Bills', NULL),
(80, 4, 'Application by members of National Assembly to Constitutional Court', NULL),
(81, 4, 'Publication of Acts', 'A Bill assented to and signed by the President becomes an Act of Parliament, must be published promptly, and takes effect when published or on a date determined in terms of the Act.'),
(82, 4, 'Safekeeping of Acts of Parliament', 'The signed copy of an Act of Parliament is conclusive evidence of the provisions of that Act and, after publication, must be entrusted to the Constitutional Court for safekeeping.');
GO

INSERT INTO [MainSchema].Subsections (SubsectionID, SectionID, SubsectionText)
VALUES
('1', 42, 'Parliament consists of—'),
('1a', 42, 'the National Assembly; and'),
('1b', 42, 'the National Council of Provinces.'),
('2', 42, 'The National Assembly and the National Council of Provinces participate in the
legislative process in the manner set out in the Constitution.'),
('3', 42, 'The National Assembly is elected to represent the people and to ensure government
by the people under the Constitution. It does this by choosing the President, by
providing a national forum for public consideration of issues, by passing legislation
and by scrutinizing and overseeing executive action.'),
('4', 42, 'The National Council of Provinces represents the provinces to ensure that provincial
interests are taken into account in the national sphere of government. It does
this mainly by participating in the national legislative process and by providing a
national forum for public consideration of issues affecting the provinces.'),
('5', 42, 'The President may summon Parliament to an extraordinary sitting at any time to
conduct special business.'),
('6', 42, 'The seat of Parliament is Cape Town, but an Act of Parliament enacted in accordance
with section 76(1) and (5) may determine that the seat of Parliament is elsewhere.'),

('0', 43, 'In the Republic, the legislative authority—'),
('0a', 43, 'of the national sphere of government is vested in Parliament, as set out in
section 44;'),
('0b', 43, 'of the provincial sphere of government is vested in the provincial legislatures,
as set out in section 104; and'),
('0c', 43, 'of the local sphere of government is vested in the Municipal Councils, as set out
in section 156.'),

('1', 44, 'The national legislative authority as vested in Parliament—'),
('1a', 44, 'confers on the National Assembly the power—'),
('1b', 44, 'confers on the National Council of Provinces the power—'),
('2', 44, 'Parliament may intervene, by passing legislation in accordance with section 76(1),
with regard to a matter falling within a functional area listed in Schedule 5, when it
is necessary—'),
('2a', 44, 'to maintain national security;'),
('2b', 44, 'to maintain economic unity;'),
('2c', 44, 'to maintain essential national standards;'),
('2d', 44, 'to establish minimum standards required for the rendering of services; or'),
('2e', 44, 'to prevent unreasonable action taken by a province which is prejudicial to the
interests of another province or to the country as a whole.'),
('3', 44, 'Legislation with regard to a matter that is reasonably necessary for, or incidental to,
the effective exercise of a power concerning any matter listed in Schedule 4 is, for all
purposes, legislation with regard to a matter listed in Schedule 4.'),
('4', 44, 'When exercising its legislative authority, Parliament is bound only by the
Constitution, and must act in accordance with, and within the limits of, the
Constitution.'),

('1', 45, 'The National Assembly and the National Council of Provinces must establish a joint
rules committee to make rules and orders concerning the joint business of the
Assembly and Council, including rules and orders—'),
('1a', 45, 'to determine procedures to facilitate the legislative process, including setting a
time limit for completing any step in the process;'),
('1b', 45, 'to establish joint committees composed of representatives from both the
Assembly and the Council to consider and report on Bills envisaged in sections
74 and 75 that are referred to such a committee;'),
('1c', 45, 'to establish a joint committee to review the Constitution at least annually; and'),
('1d', 45, 'to regulate the business of—'),
('2', 45, 'Cabinet members, members of the National Assembly and delegates to the National
Council of Provinces have the same privileges and immunities before a joint
committee of the Assembly and the Council as they have before the Assembly or the
Council.'),

('1', 46, 'The National Assembly consists of no fewer than 350 and no more than 400 women
and men elected as members in terms of an electoral system that—'),
('1a', 46, 'is prescribed by national legislation;'),
('1b', 46, 'is based on the national common voters roll;'),
('1c', 46, 'provides for a minimum voting age of 18 years; and'),
('1d', 46, 'results, in general, in proportional representation.'),
('2', 46, 'An Act of Parliament must provide a formula for determining the number of
members of the National Assembly.'),

('1', 47, 'Every citizen who is qualified to vote for the National Assembly is eligible to be a
member of the Assembly, except—'),
('1a', 47, 'anyone who is appointed by, or is in the service of, the state and receives
remuneration for that appointment or service, other than—'),
('1b', 47, 'permanent delegates to the National Council of Provinces or members of a
provincial legislature or a Municipal Council;'),
('1c', 47, 'unrehabilitated insolvents;'),
('1d', 47, 'anyone declared to be of unsound mind by a court of the Republic; or'),
('1e', 47, 'anyone who, after this section took effect, is convicted of an offence and
sentenced to more than 12 months imprisonment without the option of a
fine, either in the Republic, or outside the Republic if the conduct constituting
the offence would have been an offence in the Republic, but no one may be
regarded as having been sentenced until an appeal against the conviction or
sentence has been determined, or until the time for an appeal has expired. A
disqualification under this paragraph ends five years after the sentence has
been completed.'),
('2', 47, 'A person who is not eligible to be a member of the National Assembly in terms of
subsection (1)(a) or (b) may be a candidate for the Assembly, subject to any limits or
conditions established by national legislation.'),
('3', 47, 'A person loses membership of the National Assembly if that person—'),
('3a', 47, 'ceases to be eligible; or'),
('3b', 47, 'is absent from the Assembly without permission in circumstances for which
the rules and orders of the Assembly prescribe loss of membership; or'),
('3c', 47, 'ceases to be a member of the party that nominated that person as a member
of the Assembly.'),
('4', 47, 'Vacancies in the National Assembly must be filled in terms of national legislation.'),

('1', 49, 'The National Assembly is elected for a term of five years.'),
('2', 49, 'If the National Assembly is dissolved in terms of section 50, or when its term expires,
the President, by proclamation must call and set dates for an election, which must
be held within 90 days of the date the Assembly was dissolved or its term expired. A
proclamation calling and setting dates for an election may be issued before or after
the expiry of the term of the National Assembly.'),
('3', 49, 'If the result of an election of the National Assembly is not declared within the
period established in terms of section 190, or if an election is set aside by a court,
the President, by proclamation, must call and set dates for another election, which
must be held within 90 days of the expiry of that period or of the date on which the
election was set aside.'),
('4', 49, 'The National Assembly remains competent to function from the time it is dissolved
or its term expires, until the day before the first day of polling for the next Assembly.'),

('1', 50, 'The President must dissolve the National Assembly if—'),
('1a', 50, 'the Assembly has adopted a resolution to dissolve with a supporting vote of a
majority of its members; and'),
('1b', 50, 'three years have passed since the Assembly was elected.'),
('2', 50, 'The Acting President must dissolve the National Assembly if—'),
('2a', 50, 'there is a vacancy in the office of President; and'),
('2b', 50, 'the Assembly fails to elect a new President within 30 days after the vacancy
occurred.'),

('1', 51, 'After an election, the first sitting of the National Assembly must take place at a
time and on a date determined by the Chief Justice, but not more than 14 days after
the election result has been declared. The Assembly may determine the time and
duration of its other sittings and its recess periods.'),
('2', 51, 'The President may summon the National Assembly to an extraordinary sitting at any
time to conduct special business.'),
('3', 51, 'Sittings of the National Assembly are permitted at places other than the seat of
Parliament only on the grounds of public interest, security or convenience, and if
provided for in the rules and orders of the Assembly.'),

('1', 52, 'At the first sitting after its election, or when necessary to fill a vacancy, the National
Assembly must elect a Speaker and a Deputy Speaker from among its members.'),
('2', 52, 'The Chief Justice must preside over the election of a Speaker, or designate another
judge to do so. The Speaker presides over the election of a Deputy Speaker.'),
('3', 52, 'The procedure set out in Part A of Schedule 3 applies to the election of the Speaker
and the Deputy Speaker.'),
('4', 52, 'The National Assembly may remove the Speaker or Deputy Speaker from office by
resolution. A majority of the members of the Assembly must be present when the
resolution is adopted.'),
('5', 52, 'In terms of its rules and orders, the National Assembly may elect from among its
members other presiding officers to assist the Speaker and the Deputy Speaker.'),

('1', 53, 'Except where the Constitution provides otherwise—'),
('1a', 53, 'a majority of the members of the National Assembly must be present before a
vote may be taken on a Bill or an amendment to a Bill;'),
('1b', 53, 'at least one third of the members must be present before a vote may be taken
on any other question before the Assembly; and'),
('1c', 53, 'all questions before the Assembly are decided by a majority of the votes cast.'),
('2', 53, 'The member of the National Assembly presiding at a meeting of the Assembly has
no deliberative vote, but—'),
('2a', 53, 'must cast a deciding vote when there is an equal number of votes on each side
of a question; and'),
('2b', 53, 'may cast a deliberative vote when a question must be decided with a
supporting vote of at least two thirds of the members of the Assembly.'),

('1', 55, 'In exercising its legislative power, the National Assembly may—'),
('1a', 55, 'consider, pass, amend or reject any legislation before the Assembly; and'),
('1b', 55, 'initiate or prepare legislation, except money Bills.'),
('2', 55, 'The National Assembly must provide for mechanisms—'),
('2a', 55, 'to ensure that all executive organs of state in the national sphere of
government are accountable to it; and'),
('2b', 55, 'to maintain oversight of—'),

('0', 56, 'The National Assembly or any of its committees may—'),
('0a', 56, 'summon any person to appear before it to give evidence on oath or
affirmation, or to produce documents;'),
('0b', 56, 'require any person or institution to report to it;'),
('0c', 56, 'compel, in terms of national legislation or the rules and orders, any person or
institution to comply with a summons or requirement in terms of paragraph
(a) or (b); and'),
('0d', 56, 'receive petitions, representations or submissions from any interested persons
or institutions.'),

('1', 57, 'The National Assembly may—'),
('1a', 57, 'determine and control its internal arrangements, proceedings and procedures;
and'),
('1b', 57, 'make rules and orders concerning its business, with due regard to
representative and participatory democracy, accountability, transparency and
public involvement.'),
('2', 57, 'The rules and orders of the National Assembly must provide for—'),
('2a', 57, 'the establishment, composition, powers, functions, procedures and duration of
its committees;'),
('2b', 57, 'the participation in the proceedings of the Assembly and its committees of
minority parties represented in the Assembly, in a manner consistent with
democracy;'),
('2c', 57, 'financial and administrative assistance to each party represented in the
Assembly in proportion to its representation, to enable the party and its leader
to perform their functions in the Assembly effectively; and'),
('2d', 57, 'the recognition of the leader of the largest opposition party in the Assembly as
the Leader of the Opposition.'),

('1', 58, 'Cabinet members, Deputy Ministers and members of the National Assembly—'),
('1a', 58, 'have freedom of speech in the Assembly and in its committees, subject to its
rules and orders; and'),
('1b', 58, 'are not liable to civil or criminal proceedings, arrest, imprisonment or damages
for—'),
('2', 58, 'Other privileges and immunities of the National Assembly, Cabinet members and
members of the Assembly may be prescribed by national legislation.'),
('3', 58, 'Salaries, allowances and benefits payable to members of the National Assembly are
a direct charge against the National Revenue Fund.'),

('1', 59, 'The National Assembly must—'),
('1a', 59, 'facilitate public involvement in the legislative and other processes of the
Assembly and its committees; and'),
('1b', 59, 'conduct its business in an open manner, and hold its sittings, and those of its
committees, in public, but reasonable measures may be taken—'),
('2', 59, 'The National Assembly may not exclude the public, including the media, from a
sitting of a committee unless it is reasonable and justifiable to do so in an open and
democratic society.'),

('1', 60, 'The National Council of Provinces is composed of a single delegation from each
province consisting of ten delegates.'),
('2', 60, 'The ten delegates are—'),
('2a', 60, 'four special delegates consisting of—'),
('2b', 60, 'six permanent delegates appointed in terms of section 61(2).'),
('3', 60, 'The Premier of a province, or if the Premier is not available, a member of the
province’s delegation designated by the Premier, heads the delegation.'),

('1', 61, 'Parties represented in a provincial legislature are entitled to delegates in the
province’s delegation in accordance with the formula set out in Part B of Schedule 3.'),
('2a', 61, 'A provincial legislature must, within 30 days after the result of an election of
that legislature is declared—'),
('2b_d', 61, 'Omitted by s. 1 of the Constitution Fourteenth Amendment Act of 2008'),
('3', 61, 'The national legislation envisaged in subsection (2)(a) must ensure the
participation of minority parties in both the permanent and special delegates’
components of the delegation in a manner consistent with democracy.'),
('4', 61, 'The legislature, with the concurrence of the Premier and the leaders of the
parties entitled to special delegates in the province’s delegation, must designate
special delegates, as required from time to time, from among the members of the
legislature.'),

('1', 62, 'A person nominated as a permanent delegate must be eligible to be a member of
the provincial legislature.'),
('2', 62, 'If a person who is a member of a provincial legislature is appointed as a permanent
delegate, that person ceases to be a member of the legislature.'),
('3', 62, 'Permanent delegates are appointed for a term that expires—'),
('3a', 62, 'immediately before the first sitting of the provincial legislature after its next
election..'),
('3b_d', 62, 'Omitted by s. 2 of the Constitution Fourteenth Amendment Act of 2008.'),
('4', 62, 'A person ceases to be a permanent delegate if that person—'),
('4a', 62, 'ceases to be eligible to be a member of the provincial legislature for any reason
other than being appointed as a permanent delegate;'),
('4b', 62, 'becomes a member of the Cabinet;'),
('4c', 62, 'has lost the confidence of the provincial legislature and is recalled by the party
that nominated that person;'),
('4d', 62, 'ceases to be a member of the party that nominated that person and is recalled
by that party; or'),
('4e', 62, 'is absent from the National Council of Provinces without permission in
circumstances for which the rules and orders of the Council prescribe loss of
office as a permanent delegate.'),
('5', 62, 'Vacancies among the permanent delegates must be filled in terms of national
legislation.'),
('6', 62, 'Before permanent delegates begin to perform their functions in the National
Council of Provinces, they must swear or affirm faithfulness to the Republic and
obedience to the Constitution, in accordance with Schedule 2.'),

('1', 63, 'The National Council of Provinces may determine the time and duration of its
sittings and its recess periods.'),
('2', 63, 'The President may summon the National Council of Provinces to an extraordinary
sitting at any time to conduct special business.'),
('3', 63, 'Sittings of the National Council of Provinces are permitted at places other than the
seat of Parliament only on the grounds of public interest, security or convenience,
and if provided for in the rules and orders of the Council.'),

('1', 64, 'The National Council of Provinces must elect a Chairperson and two Deputy
Chairpersons from among the delegates.'),
('2', 64, 'The Chairperson and one of the Deputy Chairpersons are elected from among the
permanent delegates for five years unless their terms as delegates expire earlier.'),
('3', 64, 'The other Deputy Chairperson is elected for a term of one year, and must be
succeeded by a delegate from another province, so that every province is
represented in turn.'),
('4', 64, 'The Chief Justice must preside over the election of the Chairperson, or designate
another judge to do so. The Chairperson presides over the election of the Deputy
Chairpersons.'),
('5', 64, 'The procedure set out in Part A of Schedule 3 applies to the election of the
Chairperson and the Deputy Chairpersons.'),
('6', 64, 'The National Council of Provinces may remove the Chairperson or a Deputy
Chairperson from office.'),
('7', 64, 'In terms of its rules and orders, the National Council of Provinces may elect from
among the delegates other presiding officers to assist the Chairperson and Deputy
Chairpersons.'),

('1', 65, 'Except where the Constitution provides otherwise—'),
('1a', 65, '(a) each province has one vote, which is cast on behalf of the province by the head
of its delegation; and'),
('1b', 65, '(b) all questions before the National Council of Provinces are agreed when at least
five provinces vote in favour of the question.'),
('2', 65, 'An Act of Parliament, enacted in accordance with the procedure established by
either subsection (1) or subsection (2) of section 76, must provide for a uniform
procedure in terms of which provincial legislatures confer authority on their
delegations to cast votes on their behalf.'),

('1', 66, 'Cabinet members and Deputy Ministers may attend, and may speak in, the National
Council of Provinces, but may not vote.'),
('2', 66, 'The National Council of Provinces may require a Cabinet member, a Deputy Minister
or an official in the national executive or a provincial executive to attend a meeting
of the Council or a committee of the Council.'),

('0', 68, 'In exercising its legislative power, the National Council of Provinces may—'),
('0a', 68, 'consider, pass, amend, propose amendments to or reject any legislation before
the Council, in accordance with this Chapter; and'),
('0b', 68, 'initiate or prepare legislation falling within a functional area listed in Schedule
4 or other legislation referred to in section 76(3), but may not initiate or
prepare money Bills.'),

('0', 69, 'The National Council of Provinces or any of its committees may—'),
('0a', 69, 'summon any person to appear before it to give evidence on oath or affirmation
or to produce documents;'),
('0b', 69, 'require any institution or person to report to it;'),
('0c', 69, 'compel, in terms of national legislation or the rules and orders, any person or
institution to comply with a summons or requirement in terms of paragraph
(a) or (b); and'),
('0d', 69, 'receive petitions, representations or submissions from any interested persons
or institutions.'),

('1', 70, 'The National Council of Provinces may—'),
('1a', 70, 'determine and control its internal arrangements, proceedings and procedures;
and'),
('1b', 70, 'make rules and orders concerning its business, with due regard to
representative and participatory democracy, accountability, transparency and
public involvement.'),
('2', 70, 'The rules and orders of the National Council of Provinces must provide for—'),
('2a', 70, 'the establishment, composition, powers, functions, procedures and duration of
its committees;'),
('2b', 70, 'the participation of all the provinces in its proceedings in a manner consistent
with democracy; and'),
('2c', 70, 'the participation in the proceedings of the Council and its committees of
minority parties represented in the Council, in a manner consistent with
democracy, whenever a matter is to be decided in accordance with section 75.'),

('1', 71, 'Delegates to the National Council of Provinces and the persons referred to in
sections 66 and 67—'),
('1a', 71, 'have freedom of speech in the Council and in its committees, subject to its
rules and orders; and'),
('1b', 71, 'are not liable to civil or criminal proceedings, arrest, imprisonment or damages
for—'),
('2', 71, 'Other privileges and immunities of the National Council of Provinces, delegates
to the Council and persons referred to in sections 66 and 67 may be prescribed by
national legislation.'),
('3', 71, 'Salaries, allowances and benefits payable to permanent members of the National
Council of Provinces are a direct charge against the National Revenue Fund.'),

('1', 72, 'The National Council of Provinces must—'),
('1a', 72, 'facilitate public involvement in the legislative and other processes of the
Council and its committees; and'),
('1b', 72, 'conduct its business in an open manner, and hold its sittings, and those of its
committees, in public, but reasonable measures may be taken—'),
('2', 72, 'The National Council of Provinces may not exclude the public, including the media,
from a sitting of a committee unless it is reasonable and justifiable to do so in an
open and democratic society.'),

('1', 73, 'Any Bill may be introduced in the National Assembly.'),
('2', 73, 'Only a Cabinet member or a Deputy Minister, or a member or committee of the
National Assembly, may introduce a Bill in the Assembly, but only the Cabinet
member responsible for national financial matters may introduce the following Bills
in the Assembly:'),
('2a', 73, 'a money Bill; or'),
('2b', 73, 'a Bill which provides for legislation envisaged in section 214.'),
('3', 73, 'A Bill referred to in section 76(3), except a Bill referred to in subsection (2)(a) or (b)
of this section, may be introduced in the National Council of Provinces.'),
('4', 73, 'Only a member or committee of the National Council of Provinces may introduce a
Bill in the Council.'),
('5', 73, 'A Bill passed by the National Assembly must be referred to the National Council of
Provinces if it must be considered by the Council. A Bill passed by the Council must
be referred to the Assembly.'),

('1', 74, 'Section 1 and this subsection may be amended by a Bill passed by—'),
('1a', 74, 'the National Assembly, with a supporting vote of at least 75 per cent of its
members; and'),
('1b', 74, 'the National Council of Provinces, with a supporting vote of at least six
provinces.'),
('2', 74, 'Chapter 2 may be amended by a Bill passed by—'),
('2a', 74, 'the National Assembly, with a supporting vote of at least two thirds of its
members; and'),
('2b', 74, 'the National Council of Provinces, with a supporting vote of at least six
provinces.'),
('3', 74, 'Any other provision of the Constitution may be amended by a Bill passed—'),
('3a', 74, 'by the National Assembly, with a supporting vote of at least two thirds of its
members; and'),
('3b', 74, 'also by the National Council of Provinces, with a supporting vote of at least six
provinces, if the amendment—'),
('4', 74, 'A Bill amending the Constitution may not include provisions other than
constitutional amendments and matters connected with the amendments.'),
('5', 74, 'At least 30 days before a Bill amending the Constitution is introduced in terms of
section 73(2), the person or committee intending to introduce the Bill must—'),
('5a', 74, 'publish in the national Government Gazette, and in accordance with the rules
and orders of the National Assembly, particulars of the proposed amendment
for public comment;'),
('5b', 74, 'submit, in accordance with the rules and orders of the Assembly, those
particulars to the provincial legislatures for their views; and'),
('5c', 74, 'submit, in accordance with the rules and orders of the National Council of
Provinces, those particulars to the Council for a public debate, if the proposed
amendment is not an amendment that is required to be passed by the Council.'),
('6', 74, 'When a Bill amending the Constitution is introduced, the person or committee
introducing the Bill must submit any written comments received from the public
and the provincial legislatures—'),
('6a', 74, 'to the Speaker for tabling in the National Assembly; and'),
('6b', 74, 'in respect of amendments referred to in subsection (1), (2) or (3)(b), to the
Chairperson of the National Council of Provinces for tabling in the Council.'),
('7', 74, 'A Bill amending the Constitution may not be put to the vote in the National
Assembly within 30 days of—'),
('7a', 74, 'its introduction, if the Assembly is sitting when the Bill is introduced; or'),
('7b', 74, 'its tabling in the Assembly, if the Assembly is in recess when the Bill is
introduced.'),
('8', 74, 'If a Bill referred to in subsection (3)(b), or any part of the Bill, concerns only a
specific province or provinces, the National Council of Provinces may not pass the Bill
or the relevant part unless it has been approved by the legislature or legislatures of
the province or provinces concerned.'),
('9', 74, 'A Bill amending the Constitution that has been passed by the National Assembly
and, where applicable, by the National Council of Provinces, must be referred to the
President for assent.'),

('1', 75, 'When the National Assembly passes a Bill other than a Bill to which the procedure
set out in section 74 or 76 applies, the Bill must be referred to the National Council
of Provinces and dealt with in accordance with the following procedure:'),
('1a', 75, 'The Council must—'),
('1b', 75, 'If the Council passes the Bill without proposing amendments, the Bill must be
submitted to the President for assent.'),
('1c', 75, 'If the Council rejects the Bill or passes it subject to amendments, the Assembly
must reconsider the Bill, taking into account any amendment proposed by the
Council, and may—'),
('1d', 75, 'A Bill passed by the Assembly in terms of paragraph (c) must be submitted to
the President for assent.'),
('2', 75, 'When the National Council of Provinces votes on a question in terms of this section,
section 65 does not apply; instead—'),
('2a', 75, 'each delegate in a provincial delegation has one vote;'),
('2b', 75, 'at least one third of the delegates must be present before a vote may be taken
on the question; and'),
('2c', 75, 'the question is decided by a majority of the votes cast, but if there is an equal
number of votes on each side of the question, the delegate presiding must cast
a deciding vote.'),

('1', 76, 'When the National Assembly passes a Bill referred to in subsection (3), (4) or (5),
the Bill must be referred to the National Council of Provinces and dealt with in
accordance with the following procedure:'),
('1a', 76, 'The Council must—'),
('1b', 76, 'If the Council passes the Bill without amendment, the Bill must be submitted
to the President for assent.'),
('1c', 76, 'If the Council passes an amended Bill, the amended Bill must be referred to the
Assembly, and if the Assembly passes the amended Bill, it must be submitted
to the President for assent.'),
('1d', 76, 'If the Council rejects the Bill, or if the Assembly refuses to pass an amended Bill
referred to it in terms of paragraph (c), the Bill and, where applicable, also the
amended Bill, must be referred to the Mediation Committee, which may agree
on—'),
('1e', 76, 'If the Mediation Committee is unable to agree within 30 days of the Bill’s
referral to it, the Bill lapses unless the Assembly again passes the Bill, but with
a supporting vote of at least two thirds of its members.'),
('1f', 76, 'If the Mediation Committee agrees on the Bill as passed by the Assembly,
the Bill must be referred to the Council, and if passes the Bill, the Bill must be
submitted to the President for assent.'),
('1g', 76, 'If the Mediation Committee agrees on the amended Bill as passed by the
Council, the Bill must be referred to the Assembly, and if it is passed by the
Assembly, it must be submitted to the President for assent.'),
('1h', 76, 'If the Mediation Committee agrees on another version of the Bill, that version
of the Bill must be referred to both the Assembly and the Council, and if it is
passed by the Assembly and the Council, it must be submitted to the President
for assent.'),
('1i', 76, 'If a Bill referred to the Council in terms of paragraph (f) or (h) is not passed
by the Council, the Bill lapses unless the Assembly passes the Bill with a
supporting vote of at least two thirds of its members.'),
('1j', 76, 'If a Bill referred to the Assembly in terms of paragraph (g) or (h) is not passed
by the Assembly, that Bill lapses, but the Bill as originally passed by the
Assembly may again be passed by the Assembly, but with a supporting vote of
at least two thirds of its members.'),
('1k', 76, 'A Bill passed by the Assembly in terms of paragraph (e), (i) or (j) must be
submitted to the President for assent.'),
('2', 76, 'When the National Council of Provinces passes a Bill referred to in subsection (3),
the Bill must be referred to the National Assembly and dealt with in accordance with
the following procedure:'),
('2a', 76, 'The Assembly must—'),
('2b', 76, 'A Bill passed by the Assembly in terms of paragraph (a)(i) must be submitted
to the President for assent.'),
('2c', 76, 'If the Assembly passes an amended Bill, the amended Bill must be referred to
the Council, and if the Council passes the amended Bill, it must be submitted to
the President for assent.'),
('2d', 76, 'If the Assembly rejects the Bill, or if the Council refuses to pass an amended Bill
referred to it in terms of paragraph (c), the Bill and, where applicable, also the
amended Bill must be referred to the Mediation Committee, which may agree
on—'),
('2e', 76, 'If the Mediation Committee is unable to agree within 30 days of the Bill’s
referral to it, the Bill lapses.'),
('2f', 76, 'If the Mediation Committee agrees on the Bill as passed by the Council, the Bill
must be referred to the Assembly, and if the Assembly passes the Bill, the Bill
must be submitted to the President for assent.'),
('2g', 76, 'If the Mediation Committee agrees on the amended Bill as passed by the
Assembly, the Bill must be referred to the Council, and if it is passed by the
Council, it must be submitted to the President for assent.'),
('2h', 76, 'If the Mediation Committee agrees on another version of the Bill, that version
of the Bill must be referred to both the Council and the Assembly, and if it is
passed by the Council and the Assembly, it must be submitted to the President
for assent.'),
('2i', 76, 'If a Bill referred to the Assembly in terms of paragraph (f) or (h) is not passed
by the Assembly, the Bill lapses.'),
('3', 76, 'A Bill must be dealt with in accordance with the procedure established by either
subsection (1) or subsection (2) if it falls within a functional area listed in Schedule 4
or provides for legislation envisaged in any of the following sections:'),
('3a', 76, 'Section 65(2);'),
('3b', 76, 'section 163;'),
('3c', 76, 'section 182;'),
('3d', 76, 'section 195(3) and (4);'),
('3e', 76, 'section 196; and'),
('3f', 76, 'section 197.'),
('4', 76, 'A Bill must be dealt with in accordance with the procedure established by
subsection (1) if it provides for legislation—'),
('4a', 76, 'envisaged in section 44(2) or 220(3); or'),
('4b', 76, 'envisaged in Chapter 13, and which includes any provision affecting the
financial interests of the provincial sphere of government.'),
('5', 76, 'A Bill envisaged in section 42(6) must be dealt with in accordance with the
procedure established by subsection (1), except that—'),
('5a', 76, 'when the National Assembly votes on the Bill, the provisions of section 53(1)
do not apply; instead, the Bill may be passed only if a majority of the members
of the Assembly vote in favour of it; and'),
('5b', 76, 'if the Bill is referred to the Mediation Committee, the following rules apply:'),
('6', 76, 'This section does not apply to money Bills.'),

('1', 77, 'A Bill is a money Bill if it—'),
('1a', 77, 'appropriates money;'),
('1b', 77, 'imposes national taxes, levies, duties or surcharges;'),
('1c', 77, 'abolishes or reduces, or grants exemptions from, any national taxes, levies,
duties or surcharges; or'),
('1d', 77, 'authorises direct charges against the National Revenue Fund, except a Bill
envisaged in section 214 authorising direct charges.'),
('2', 77, 'A money Bill may not deal with any other matter except—'),
('2a', 77, 'a subordinate matter incidental to the appropriation of money;'),
('2b', 77, 'the imposition, abolition or reduction of national taxes, levies, duties or
surcharges;'),
('2c', 77, 'the granting of exemption from national taxes, levies, duties or surcharges; or'),
('2d', 77, 'the authorisation of direct charges against the National Revenue Fund.'),
('3', 77, 'All money Bills must be considered in accordance with the procedure established by
section 75. An Act of Parliament must provide for a procedure to amend money Bills
before Parliament.'),

('1', 78, 'The Mediation Committee consists of—'),
('1a', 78, 'nine members of the National Assembly elected by the Assembly in accordance
with a procedure that is prescribed by the rules and orders of the Assembly and
results in the representation of parties in substantially the same proportion
that the parties are represented in the Assembly; and'),
('1b', 78, 'one delegate from each provincial delegation in the National Council of
Provinces, designated by the delegation.'),
('2', 78, 'The Mediation Committee has agreed on a version of a Bill, or decided a question,
when that version, or one side of the question, is supported by—'),
('2a', 78, 'at least five of the representatives of the National Assembly; and'),
('2b', 78, 'at least five of the representatives of the National Council of Provinces.'),

('1', 79, 'The President must either assent to and sign a Bill passed in terms of this Chapter or,
if the President has reservations about the constitutionality of the Bill, refer it back
to the National Assembly for reconsideration.'),
('2', 79, 'The joint rules and orders must provide for the procedure for the reconsideration
of a Bill by the National Assembly and the participation of the National Council of
Provinces in the process.'),
('3', 79, 'The National Council of Provinces must participate in the reconsideration of a Bill
that the President has referred back to the National Assembly if—'),
('3a', 79, 'the President’s reservations about the constitutionality of the Bill relate to a
procedural matter that involves the Council; or'),
('3b', 79, 'section 74(1), (2) or (3)(b) or 76 was applicable in the passing of the Bill.'),
('4', 79, 'If, after reconsideration, a Bill fully accommodates the President’s reservations, the
President must assent to and sign the Bill; if not, the President must either—'),
('4a', 79, 'assent to and sign the Bill; or'),
('4b', 79, 'refer it to the Constitutional Court for a decision on its constitutionality.'),
('5', 79, 'If the Constitutional Court decides that the Bill is constitutional, the President must
assent to and sign it.'),

('1', 80, 'Members of the National Assembly may apply to the Constitutional Court for an
order declaring that all or part of an Act of Parliament is unconstitutional.'),
('2', 80, 'An application—'),
('2a', 80, 'must be supported by at least one third of the members of the National
Assembly; and'),
('2b', 80, 'must be made within 30 days of the date on which the President assented to
and signed the Act.'),
('3', 80, 'The Constitutional Court may order that all or part of an Act that is the subject of an
application in terms of subsection (1) has no force until the Court has decided the
application if—'),
('3a', 80, 'the interests of justice require this; and'),
('3b', 80, 'the application has a reasonable prospect of success.'),
('4', 80, 'If an application is unsuccessful, and did not have a reasonable prospect of success,
the Constitutional Court may order the applicants to pay costs.');
GO

INSERT INTO [MainSchema].Clauses  (ClauseID, SectionID, SubsectionID, ClauseText)
VALUES
('i', 44, '1a', 'to amend the Constitution;'),
('ii', 44, '1a', 'to pass legislation with regard to any matter, including a matter within a
functional area listed in Schedule 4, but excluding, subject to subsection
(2), a matter within a functional area listed in Schedule 5; and'),
('iii', 44, '1a', 'to assign any of its legislative powers, except the power to amend the
Constitution, to any legislative body in another sphere of government;
and'),
('i', 44, '1b', 'to participate in amending the Constitution in accordance with section
74;'),
('ii', 44, '1b', 'to pass, in accordance with section 76, legislation with regard to any
matter within a functional area listed in Schedule 4 and any other matter
required by the Constitution to be passed in accordance with section 76;
and'),
('iii', 44, '1b', 'to consider, in accordance with section 75, any other legislation passed
by the National Assembly.'),

('i', 45, '1d', 'the joint rules committee;'),
('ii', 45, '1d', 'the Mediation Committee;'),
('iii', 45, '1d', 'the constitutional review committee; and'),
('iv', 45, '1d', 'any joint committees established in terms of paragraph (b).'),

('i', 47, '1a', 'the President, Deputy President, Ministers and Deputy Ministers; and'),
('ii', 47, '1a', 'other office-bearers whose functions are compatible with the functions
of a member of the Assembly, and have been declared compatible with
those functions by national legislation;'),

('i', 55, '2b', 'the exercise of national executive authority, including the
implementation of legislation; and'),
('ii', 55, '2b', 'any organ of state.'),

('i', 58, '1b', 'anything that they have said in, produced before or submitted to the
Assembly or any of its committees; or'),
('ii', 58, '1b', 'anything revealed as a result of anything that they have said in,
produced before or submitted to the Assembly or any of its committees.'),

('i', 59, '1b', 'to regulate public access, including access of the media, to the Assembly
and its committees; and'),
('ii', 59, '1b', 'to provide for the searching of any person and, where appropriate, the
refusal of entry to, or the removal of, any person.'),

('i', 60, '2a', 'the Premier of the province or, if the Premier is not available, any
member of the provincial legislature designated by the Premier either
generally or for any specific business before the National Council of
Provinces; and'),
('ii', 60, '2a', 'three other special delegates; and'),

('i', 61, '2a', 'determine, in accordance with national legislation, how many of each
party’s delegates are to be permanent delegates and how many are to be
special delegates; and'),
('ii', 61, '2a', 'appoint the permanent delegates in accordance with the nominations of
the parties.'),

('i', 71, '1b', 'anything that they have said in, produced before or submitted to the
Council or any of its committees; or'),
('ii', 71, '1b', 'anything revealed as a result of anything that they have said in,
produced before or submitted to the Council or any of its committees.'),

('i', 72, '1b', 'to regulate public access, including access of the media, to the Council
and its committees; and'),
('ii', 72, '1b', 'to provide for the searching of any person and, where appropriate, the
refusal of entry to, or the removal of, any person.'),

('i', 74, '3b', 'relates to a matter that affects the Council;'),
('ii', 74, '3b', 'alters provincial boundaries, powers, functions or institutions; or'),
('iii', 74, '3b', 'amends a provision that deals specifically with a provincial matter.'),

('i', 75, '1a', 'pass the Bill;'),
('ii', 75, '1a', 'pass the Bill subject to amendments proposed by it; or'),
('iii', 75, '1a', 'reject the Bill.'),

('i', 75, '1c', 'pass the Bill again, either with or without amendments; or'),
('ii', 75, '1c', 'decide not to proceed with the Bill.'),

('i', 76, '1a', 'pass the Bill;'),
('ii', 76, '1a', 'pass an amended Bill; or'),
('iii', 76, '1a', 'reject the Bill.'),

('i', 76, '1d', 'the Bill as passed by the Assembly;'),
('ii', 76, '1d', 'the amended Bill as passed by the Council; or'),
('iii', 76, '1d', 'another version of the Bill.'),

('i', 76, '2a', 'pass the Bill;'),
('ii', 76, '2a', 'pass an amended Bill; or'),
('iii', 76, '2a', 'reject the Bill.'),

('i', 76, '2d', 'the Bill as passed by the Council;'),
('ii', 76, '2d', 'the amended Bill as passed by the Assembly; or'),
('iii', 76, '2d', 'another version of the Bill.'),

('i', 76, '5b', 'If the National Assembly considers a Bill envisaged in subsection (1)(g)
or (h), that Bill may be passed only if a majority of the members of the
Assembly vote in favour of it.'),
('ii', 76, '5b', 'If the National Assembly considers or reconsiders a Bill envisaged in
subsection (1)(e), (i) or (j), that Bill may be passed only if at least two
thirds of the members of the Assembly vote in favour of it.');
GO

/* /////////////// Chapter 5's contents /////////// */
INSERT INTO [MainSchema].Sections (SectionID, ChapterID, SectionTitle, SectionText)
VALUES
(83, 5, 'The President', NULL),
(84, 5, 'Powers and functions of President', NULL),
(85, 5, 'Executive authority of the Republic', NULL),
(86, 5, 'Election of President', NULL),
(87, 5, 'Assumption of office by President', 'When elected President, a person ceases to be a member of the National Assembly and,
within five days, must assume office by swearing or affirming faithfulness to the Republic
and obedience to the Constitution, in accordance with Schedule 2.'),
(88, 5, 'Term of office of President', NULL),
(89, 5, 'Removal of President', NULL),
(90, 5, 'Acting President', NULL),
(91, 5, 'Cabinet', NULL),
(92, 5, 'Accountability and responsibilities', NULL),
(93, 5, 'Deputy Ministers', NULL),
(94, 5, 'Continuation of Cabinet after elections', 'When an election of the National Assembly is held, the Cabinet, the Deputy President,
Ministers and any Deputy Ministers remain competent to function until the person elected
President by the next Assembly assumes office.'),
(95, 5, 'Oath or affirmation', 'Before the President, Before the Deputy President, Ministers and any Deputy Ministers begin to perform their
functions, they must swear or affirm faithfulness to the Republic and obedience to the
Constitution, in accordance with Schedule 2.'),
(96, 5, 'Conduct of Cabinet members and Deputy Ministers', NULL),
(97, 5, 'Transfer of functions', NULL),
(98, 5, 'Temporary assignment of functions', 'The President may assign to a Cabinet member any power or function of another member
who is absent from office or is unable to exercise that power or perform that function.'),
(99, 5, 'Assignment of functions', NULL),
(100, 5, 'National supervision of provincial administration', NULL),
(101, 5, 'Executive decisions', NULL),
(102, 5, 'Motions of no confidence', NULL);

INSERT INTO [MainSchema].Subsections (SubsectionID, SectionID, SubsectionText)
VALUES	
('0', 83, 'The President—'),
('0a', 83, 'is the Head of State and head of the national executive;'),
('0b', 83, 'must uphold, defend and respect the Constitution as the supreme law
of the Republic; and'),
('0c', 83, 'promotes the unity of the nation and that which will advance the
Republic.'),

('1', 84, 'The President has the powers entrusted by the Constitution and legislation,
including those necessary to perform the functions of Head of State and head of the
national executive.'),
('2', 84, 'The President is responsible for—'),
('2a', 84, 'assenting to and signing Bills;'),
('2b', 84, 'referring a Bill back to the National Assembly for reconsideration of the Bill’s
constitutionality;'),
('2c', 84, 'referring a Bill to the Constitutional Court for a decision on the Bill’s
constitutionality;'),
('2d', 84, 'summoning the National Assembly, the National Council of Provinces or
Parliament to an extraordinary sitting to conduct special business;'),
('2e', 84, 'making any appointments that the Constitution or legislation requires the
President to make, other than as head of the national executive;'),
('2f', 84, 'appointing commissions of inquiry;'),
('2g', 84, 'calling a national referendum in terms of an Act of Parliament;'),
('2h', 84, 'receiving and recognising foreign diplomatic and consular representatives;'),
('2i', 84, 'appointing ambassadors, plenipotentiaries, and diplomatic and consular
representatives;'),
('2j', 84, 'pardoning or reprieving offenders and remitting any fines, penalties or
forfeitures; and'),
('2k', 84, 'conferring honours.'),

('1', 85, 'The executive authority of the Republic is vested in the President.'),
('2', 85, 'The President exercises the executive authority, together with the other members of
the Cabinet, by—'),
('2a', 85, 'implementing national legislation except where the Constitution or an Act of
Parliament provides otherwise;'),
('2b', 85, 'developing and implementing national policy;'),
('2c', 85, 'co-ordinating the functions of state departments and administrations;'),
('2d', 85, 'preparing and initiating legislation; and'),
('2e', 85, 'performing any other executive function provided for in the Constitution or in
national legislation.'),

('1', 86, 'At its first sitting after its election, and whenever necessary to fill a vacancy, the
National Assembly must elect a woman or a man from among its members to be the
President.'),
('2', 86, 'The Chief Justice must preside over the election of the President, or designate
another judge to do so. The procedure set out in Part A of Schedule 3 applies to the
election of the President.'),
('3', 86, 'An election to fill a vacancy in the office of President must be held at a time and on
a date determined by the Chief Justice, but not more than 30 days after the vacancy
occurs.'),

('1', 88, 'The President’s term of office begins on assuming office and ends upon a vacancy
occurring or when the person next elected President assumes office.'),
('2', 88, 'No person may hold office as President for more than two terms, but when a person
is elected to fill a vacancy in the office of President, the period between that election
and the next election of a President is not regarded as a term.'),

('1', 89, 'The National Assembly, by a resolution adopted with a supporting vote of at least
two thirds of its members, may remove the President from office only on the
grounds of—'),
('1a', 89, 'a serious violation of the Constitution or the law;'),
('1b', 89, 'serious misconduct; or'),
('1c', 89, 'inability to perform the functions of office.'),
('2', 89, 'Anyone who has been removed from the office of President in terms of subsection
(1)(a) or (b) may not receive any benefits of that office, and may not serve in any
public office.'),

('1', 90, 'When the President is absent from the Republic or otherwise unable to fulfil the
duties of President, or during a vacancy in the office of President, an office-bearer in
the order below acts as President:'),
('1a', 90, 'The Deputy President.'),
('1b', 90, 'A Minister designated by the President.'),
('1c', 90, 'A Minister designated by the other members of the Cabinet.'),
('1d', 90, 'The Speaker, until the National Assembly designates one of its other members.'),
('2', 90, 'An Acting President has the responsibilities, powers and functions of the President.'),
('3', 90, 'Before assuming the responsibilities, powers and functions of the President, the
Acting President must swear or affirm faithfulness to the Republic and obedience to
the Constitution, in accordance with Schedule 2.'),
('4', 90, 'A person who as Acting President has sworn or affirmed faithfulness to the Republic
need not repeat the swearing or affirming procedure for any subsequent term as
Acting President during the period ending when the person next elected President
assumes office.'),

('1', 91, 'The Cabinet consists of the President, as head of the Cabinet, a Deputy President and
Ministers.'),
('2', 91, 'The President appoints the Deputy President and Ministers, assigns their powers
and functions, and may dismiss them.'),
('3', 91, 'The President—'),
('3a', 91, 'must select the Deputy President from among the members of the National
Assembly;'),
('3b', 91, 'may select any number of Ministers from among the members of the
Assembly; and'),
('3c', 91, 'may select no more than two Ministers from outside the Assembly.'),
('4', 91, 'The President must appoint a member of the Cabinet to be the leader of
government business in the National Assembly.'),
('5', 91, 'The Deputy President must assist the President in the execution of the functions of
government.'),

('1', 92, 'The Deputy President and Ministers are responsible for the powers and functions of
the executive assigned to them by the President.'),
('2', 92, 'Members of the Cabinet are accountable collectively and individually to Parliament
for the exercise of their powers and the performance of their functions.'),
('3', 92, 'Members of the Cabinet must—'),
('3a', 92, 'act in accordance with the Constitution; ands'),
('3b', 92, 'provide Parliament with full and regular reports concerning matters under
their control.'),

('1', 93, 'The President may appoint—'),
('1a', 93, 'any number of Deputy Ministers from among the members of the National
Assembly; and'),
('1b', 93, 'no more than two Deputy Ministers from outside the Assembly, to
assist the members of the Cabinet, and may dismiss them.'),
('2', 93, 'Deputy Ministers appointed in terms of subsection (1)(b) are accountable to
Parliament for the exercise of their powers and the performance of their functions.'),

('1', 96, 'Members of the Cabinet and Deputy Ministers must act in accordance with a code of
ethics prescribed by national legislation.'),
('2', 96, 'Members of the Cabinet and Deputy Ministers may not—'),
('2a', 96, 'undertake any other paid work;'),
('2b', 96, 'act in any way that is inconsistent with their office, or expose themselves
to any situation involving the risk of a conflict between their official
responsibilities and private interests; or'),
('2c', 96, 'use their position or any information entrusted to them, to enrich themselves
or improperly benefit any other person.'),

('0', 97, 'The President by proclamation may transfer to a member of the Cabinet—'),
('0a', 97, 'the administration of any legislation entrusted to another member; or'),
('0b', 97, 'any power or function entrusted by legislation to another member.'),

('0', 99, 'A Cabinet member may assign any power or function that is to be exercised or performed
in terms of an Act of Parliament to a member of a provincial Executive Council or to a
Municipal Council. An assignment—'),
('0a', 99, 'must be in terms of an agreement between the relevant Cabinet member and
the Executive Council member or Municipal Council;'),
('0b', 99, 'must be consistent with the Act of Parliament in terms of which the relevant
power or function is exercised or performed; and'),
('0c', 99, 'takes effect upon proclamation by the President.'),

('1', 100, 'When a province cannot or does not fulfil an executive obligation in terms of the
Constitution or legislation, the national executive may intervene by taking any
appropriate steps to ensure fulfilment of that obligation, including—'),
('1a', 100, 'issuing a directive to the provincial executive, describing the extent of the
failure to fulfil its obligations and stating any steps required to meet its
obligations; and'),
('1b', 100, 'assuming responsibility for the relevant obligation in that province to the
extent necessary to—'),
('2', 100, 'If the national executive intervenes in a province in terms of subsection (1)(b)—'),
('2a', 100, 'it must submit a written notice of the intervention to the National Council of
Provinces within 14 days after the intervention began;'),
('2b', 100, 'the intervention must end if the Council disapproves the intervention within
180 days after the intervention began or by the end of that period has not
approved the intervention; and'),
('2c', 100, 'the Council must, while the intervention continues, review the intervention
regularly and may make any appropriate recommendations to the national
executive.'),
('3', 100, 'National legislation may regulate the process established by this section.'),

('1', 101, 'A decision by the President must be in writing if it—'),
('1a', 101, 'is taken in terms of legislation; or'),
('1b', 101, 'has legal consequences.'),
('2', 101, 'A written decision by the President must be countersigned by another Cabinet
member if that decision concerns a function assigned to that other Cabinet member.'),
('3', 101, 'Proclamations, regulations and other instruments of subordinate legislation must
be accessible to the public.'),
('4', 101, 'National legislation may specify the manner in which, and the extent to which,
instruments mentioned in subsection (3) must be—'),
('4a', 101, 'tabled in Parliament; and'),
('4b', 101, 'approved by Parliament.'),

('1', 102, 'If the National Assembly, by a vote supported by a majority of its members, passes a
motion of no confidence in the Cabinet excluding the President, the President must
reconstitute the Cabinet.'),
('2', 102, 'If the National Assembly, by a vote supported by a majority of its members, passes
a motion of no confidence in the President, the President and the other members of
the Cabinet and any Deputy Ministers must resign.');
GO

INSERT INTO [MainSchema].Clauses (ClauseID, SectionID, SubsectionID, ClauseText)
VALUES	
('i', 100, '1b', 'maintain essential national standards or meet established minimum
standards for the rendering of a service;'),
('ii', 100, '1b', 'maintain economic unity;'),
('iii', 100, '1b', 'maintain national security; or'),
('iv', 100, '1b', 'prevent that province from taking unreasonable action that is prejudicial
to the interests of another province or to the country as a whole.');
GO

/* /////////////// Chapter 6's contents /////////// */
INSERT INTO [MainSchema].Sections (SectionID, ChapterID, SectionTitle, SectionText)
VALUES
(103, 6, 'Provinces', NULL),
(104, 6, 'Legislative authority of provinces', NULL),
(105, 6, 'Composition and election of provincial legislatures', NULL),
(106, 6, 'Membership', NULL),
(107, 6, 'Oath or affirmation', 'Before members of a provincial legislature begin to perform their functions in the
legislature, they must swear or affirm faithfulness to the Republic and obedience to the
Constitution, in accordance with Schedule 2.'),
(108, 6, 'Duration of provincial legislatures', NULL),
(109, 6, 'Dissolution of provincial legislatures before expiry of term', NULL),
(110, 6, 'Sittings and recess periods', NULL),
(111, 6, 'Speakers and Deputy Speakers', NULL),
(112, 6, 'Decisions', NULL),
(113, 6, 'Permanent delegates'' rights in provincial legislatures', 'A province’s permanent delegates to the National Council of Provinces may attend, and
may speak in, their provincial legislature and its committees, but may not vote. The
legislature may require a permanent delegate to attend the legislature or its committees.'),
(114, 6, 'Powers of provincial legislatures', NULL),
(115, 6, 'Evidence or information before provincial legislatures', NULL),
(116, 6, 'Internal arrangements, proceedings and procedures of provincial legislatures', NULL),
(117, 6, 'Privilege', NULL),
(118, 6, 'Public access to and involvement in provincial legislatures', NULL),
(119, 6, 'Introduction of Bills', 'Only members of the Executive Council of a province or a committee or member of a
provincial legislature may introduce a Bill in the legislature; but only the member of the
Executive Council who is responsible for financial matters in the province may introduce a
money Bill in the legislature.'),
(120, 6, 'Money Bills', NULL),
(121, 6, 'Assent to Bills', NULL),
(122, 6, 'Application by members to Constitutional Court', NULL),
(123, 6, 'Publication of provincial Acts', 'A Bill assented to and signed by the Premier of a province becomes a provincial Act, must
be published promptly and takes effect when published or on a date determined in terms
of the Act.'),
(124, 6, 'Safekeeping of provincial Acts', 'The signed copy of a provincial Act is conclusive evidence of the provisions of that Act and,
after publication, must be entrusted to the Constitutional Court for safekeeping.'),
(125, 6, 'Executive authority of provinces', NULL),
(126, 6, 'Assignment of functions', NULL),
(127, 6, 'Powers and functions of Premiers', NULL),
(128, 6, 'Election of Premiers', NULL),
(129, 6, 'Assumption of office by Premiers', 'A Premier-elect must assume office within five days of being elected, by swearing or
affirming faithfulness to the Republic and obedience to the Constitution, in accordance
with Schedule 2.'),
(130, 6, 'Term of office and removal of Premiers', NULL),
(131, 6, 'Acting Premiers', NULL),
(132, 6, 'Executive Councils', NULL),
(133, 6, 'Accountability and responsibilities', NULL),
(134, 6, 'Continuation of Executive Councils after elections', 'When an election of a provincial legislature is held, the Executive Council and its members
remain competent to function until the person elected Premier by the next legislature
assumes office.'),
(135, 6, 'Oath or affirmation', 'Before members of the Executive Council of a province begin to perform their functions,
they must swear or affirm faithfulness to the Republic and obedience to the Constitution,
in accordance with Schedule 2.'),
(136, 6, 'Conduct of members of Executive Councils', NULL),
(137, 6, 'Transfer of functions', NULL),
(138, 6, 'Temporary assignment of functions', 'The Premier of a province may assign to a member of the Executive Council any power or
function of another member who is absent from office or is unable to exercise that power
or perform that function.'),
(139, 6, 'Provincial intervention in local government', NULL),
(140, 6, 'Executive decisions', NULL),
(141, 6, 'Motions of no confidence', NULL),
(142, 6, 'Adoption of provincial constitutions', 'A provincial legislature may pass a constitution for the province or, where applicable,
amend its constitution, if at least two thirds of its members vote in favour of the Bill.'),
(143, 6, 'Contents of provincial constitutions', NULL),
(144, 6, 'Certification of provincial constitutions', NULL),
(145, 6, 'Signing, publication and safekeeping of provincial constitutions', NULL),
(146, 6, 'Conflicts between national and provincial legislation', NULL),
(147, 6, 'Other conflicts', NULL),
(148, 6, 'Conflicts that cannot be resolved', 'If a dispute concerning a conflict cannot be resolved by a court, the national legislation
prevails over the provincial legislation or provincial constitution.'),
(149, 6, 'Status of legislation that does not prevail', 'A decision by a court that legislation prevails over other legislation does not invalidate that
other legislation, but that other legislation becomes inoperative for as long as the conflict
remains.'),
(150, 6, 'Interpretation of conflicts', 'When considering an apparent conflict between national and provincial legislation, or
between national legislation and a provincial constitution, every court must prefer any
reasonable interpretation of the legislation or constitution that avoids a conflict, over any
alternative interpretation that results in a conflict.');
GO

INSERT INTO [MainSchema].Subsections(SubsectionID, SectionID, SubsectionText)
VALUES
('1', 103, 'The Republic has the following provinces:'),
('1a', 103, 'Eastern Cape;'),
('1b', 103, 'Free State;'),
('1c', 103, 'Gauteng;'),
('1d', 103, 'KwaZulu-Natal;'),
('1e', 103, 'Limpopo;'),
('1f', 103, 'Mpumalanga;'),
('1g', 103, 'Northern Cape;'),
('1h', 103, 'North West;'),
('1i', 103, 'Western Cape.'),
('2', 103, 'The geographical areas of the respective provinces comprise the sum of the
indicated geographical areas reflected in the various maps referred to in the Notice
listed in Schedule 1A.'),
('3a', 103, 'Whenever the geographical area of a province is re-determined by an
amendment to the Constitution, an Act of Parliament may provide for
measures to regulate, within a reasonable time, the legal, practical and any
other consequences of the re-determination.'),
('3b', 103, 'An Act of Parliament envisaged in paragraph (a) may be enacted and
implemented before such amendment to the Constitution takes effect, but any
provincial functions, assets, rights, obligations, duties or liabilities may only be
transferred in terms of that Act after that amendment to the Constitution takes
effect.'),

('1', 104, 'The legislative authority of a province is vested in its provincial legislature, and
confers on the provincial legislature the power—'),
('1a', 104, 'to pass a constitution for its province or to amend any constitution passed by it
in terms of sections 142 and 143;'),
('1b', 104, 'to pass legislation for its province with regard to—'),
('1c', 104, 'to assign any of its legislative powers to a Municipal Council in that province.'),
('2', 104, 'The legislature of a province, by a resolution adopted with a supporting vote of at
least two thirds of its members, may request Parliament to change the name of that
province.'),
('3', 104, 'A provincial legislature is bound only by the Constitution and, if it has passed a
constitution for its province, also by that constitution, and must act in accordance
with, and within the limits of, the Constitution and that provincial constitution.'),
('4', 104, 'Provincial legislation with regard to a matter that is reasonably necessary for, or
incidental to, the effective exercise of a power concerning any matter listed in
Schedule 4, is for all purposes legislation with regard to a matter listed in Schedule
4.'),
('5', 104, 'A provincial legislature may recommend to the National Assembly legislation
concerning any matter outside the authority of that legislature, or in respect of
which an Act of Parliament prevails over a provincial law.'),

('1', 105, 'A provincial legislature consists of women and men elected as members in terms
of an electoral system that—'),
('1a', 105, 'is prescribed by national legislation;'),
('1b', 105, 'is based on that province’s segment of the national common voters roll;'),
('1c', 105, 'provides for a minimum voting age of 18 years; and'),
('1d', 105, 'results, in general, in proportional representation.'),
('2', 105, 'A provincial legislature consists of between 30 and 80 members. The number of
members, which may differ among the provinces, must be determined in terms of a
formula prescribed by national legislation.'),

('1', 106, 'Every citizen who is qualified to vote for the National Assembly is eligible to be a
member of a provincial legislature, except—'),
('1a', 106, 'anyone who is appointed by, or is in the service of, the state and receives
remuneration for that appointment or service, other than—'),
('1b', 106, 'members of the National Assembly, permanent delegates to the National
Council of Provinces or members of a Municipal Council;'),
('1c', 106, 'unrehabilitated insolvents;'),
('1d', 106, 'anyone declared to be of unsound mind by a court of the Republic; or'),
('1e', 106, 'anyone who, after this section took effect, is convicted of an offence and
sentenced to more than 12 months’ imprisonment without the option of a
fine, either in the Republic, or outside the Republic if the conduct constituting
the offence would have been an offence in the Republic, but no one may be
regarded as having been sentenced until an appeal against the conviction or
sentence has been determined, or until the time for an appeal has expired. A
disqualification under this paragraph ends five years after the sentence has
been completed.'),
('2', 106, 'A person who is not eligible to be a member of a provincial legislature in terms of
subsection (1)(a) or (b) may be a candidate for the legislature, subject to any limits
or conditions established by national legislation.'),
('3', 106, 'A person loses membership of a provincial legislature if that person—'),
('3a', 106, 'ceases to be eligible;'),
('3b', 106, 'is absent from the legislature without permission in circumstances for which
the rules and orders of the legislature prescribe loss of membership; or'),
('3c', 106, 'ceases to be a member of the party that nominated that person as a member
of the legislature.'),
('4', 106, 'Vacancies in a provincial legislature must be filled in terms of national legislation.'),

('1', 108, 'A provincial legislature is elected for a term of five years.'),
('2', 108, 'If a provincial legislature is dissolved in terms of section 109, or when its term
expires, the Premier of the province, by proclamation, must call and set dates
for an election, which must be held within 90 days of the date the legislature
was dissolved or its term expired. A proclamation calling and setting dates for
an election may be issued before or after the expiry of the term of a provincial
legislature.'),
('3', 108, 'If the result of an election of a provincial legislature is not declared within the period
referred to in section 190, or if an election is set aside by a court, the President, by
proclamation, must call and set dates for another election, which must be held
within 90 days of the expiry of that period or of the date on which the election was
set aside.'),
('4', 108, '4) A provincial legislature remains competent to function from the time it is dissolved
or its term expires, until the day before the first day of polling for the next
legislature.'),

('1', 109, 'The Premier of a province must dissolve the provincial legislature if—'),
('1a', 109, 'the legislature has adopted a resolution to dissolve with a supporting vote of a
majority of its members; and'),
('1b', 109, 'three years have passed since the legislature was elected.'),
('2', 109, 'An Acting Premier must dissolve the provincial legislature if—'),
('2a', 109, 'there is a vacancy in the office of Premier; and'),
('2b', 109, 'the legislature fails to elect a new Premier within 30 days after the vacancy
occurred.'),

('1', 110, 'After an election, the first sitting of a provincial legislature must take place at a time
and on a date determined by a judge designated by the Chief Justice, but not more
than 14 days after the election result has been declared. A provincial legislature may
determine the time and duration of its other sittings and its recess periods.'),
('2', 110, 'The Premier of a province may summon the provincial legislature to an
extraordinary sitting at any time to conduct special business.'),
('3', 110, 'A provincial legislature may determine where it ordinarily will sit.'),

('1', 111, 'At the first sitting after its election, or when necessary to fill a vacancy, a provincial
legislature must elect a Speaker and a Deputy Speaker from among its members.'),
('2', 111, 'A judge designated by the Chief Justice must preside over the election of a Speaker.
The Speaker presides over the election of a Deputy Speaker.'),
('3', 111, 'The procedure set out in Part A of Schedule 3 applies to the election of Speakers and
Deputy Speakers.'),
('4', 111, 'A provincial legislature may remove its Speaker or Deputy Speaker from office by
resolution. A majority of the members of the legislature must be present when the
resolution is adopted.'),
('5', 111, 'In terms of its rules and orders, a provincial legislature may elect from among its
members other presiding officers to assist the Speaker and the Deputy Speaker.'),

('1', 112, 'Except where the Constitution provides otherwise—'),
('1a', 112, 'a majority of the members of a provincial legislature must be present before a
vote may be taken on a Bill or an amendment to a Bill;'),
('1b', 112, 'at least one third of the members must be present before a vote may be taken
on any other question before the legislature; and'),
('1c', 112, 'all questions before a provincial legislature are decided by a majority of the
votes cast.'),
('2', 112, 'The member presiding at a meeting of a provincial legislature has no deliberative
vote, but—'),
('2a', 112, 'must cast a deciding vote when there is an equal number of votes on each side
of a question; and'),
('2b', 112, 'may cast a deliberative vote when a question must be decided with a
supporting vote of at least two thirds of the members of the legislature.'),

('1', 114, 'In exercising its legislative power, a provincial legislature may—'),
('1a', 114, 'consider, pass, amend or reject any Bill before the legislature; and'),
('1b', 114, 'initiate or prepare legislation, except money Bills.'),
('2', 114, 'A provincial legislature must provide for mechanisms—'),
('2a', 114, 'to ensure that all provincial executive organs of state in the province are
accountable to it; and'),
('2b', 114, 'to maintain oversight of—'),

('0', 115, 'A provincial legislature or any of its committees may—'),
('0a', 115, 'summon any person to appear before it to give evidence on oath or
affirmation, or to produce documents;'),
('0b', 115, 'require any person or provincial institution to report to it;'),
('0c', 115, 'compel, in terms of provincial legislation or the rules and orders, any
person or institution to comply with a summons or requirement in terms of
paragraph (a) or (b); and'),
('0d', 115, 'receive petitions, representations or submissions from any interested
persons or institutions.'),

('1', 116, 'A provincial legislature may—'),
('1a', 116, 'determine and control its internal arrangements, proceedings and procedures;
and'),
('1b', 116, 'make rules and orders concerning its business, with due regard to
representative and participatory democracy, accountability, transparency and
public involvement.'),
('2', 116, 'The rules and orders of a provincial legislature must provide for—'),
('2a', 116, 'the establishment, composition, powers, functions, procedures and duration of
its committees;'),
('2b', 116, 'the participation in the proceedings of the legislature and its committees of
minority parties represented in the legislature, in a manner consistent with
democracy;'),
('2c', 116, 'financial and administrative assistance to each party represented in the
legislature, in proportion to its representation, to enable the party and its
leader to perform their functions in the legislature effectively; and'),
('2d', 116, 'the recognition of the leader of the largest opposition party in the legislature,
as the Leader of the Opposition.'),

('1', 117, 'Members of a provincial legislature and the province’s permanent delegates to the
National Council of Provinces—'),
('1a', 117, 'have freedom of speech in the legislature and in its committees, subject to its
rules and orders; and'),
('1b', 117, 'are not liable to civil or criminal proceedings, arrest, imprisonment or damages
for—'),
('2', 117, 'Other privileges and immunities of a provincial legislature and its members may be
prescribed by national legislation.'),
('3', 117, 'Salaries, allowances and benefits payable to members of a provincial legislature are
a direct charge against the Provincial Revenue Fund.'),

('1', 118, 'A provincial legislature must—'),
('1a', 118, 'facilitate public involvement in the legislative and other processes of the
legislature and its committees; and'),
('1b', 118, 'conduct its business in an open manner, and hold its sittings, and those of its
committees, in public, but reasonable measures may be taken—'),
('2', 118, 'A provincial legislature may not exclude the public, including the media, from a
sitting of a committee unless it is reasonable and justifiable to do so in an open and
democratic society.'),

('1', 120, 'A Bill is a money Bill if it—'),
('1a', 120, 'appropriates money;'),
('1b', 120, 'imposes provincial taxes, levies, duties or surcharges;'),
('1c', 120, 'abolishes or reduces, or grants exemptions from, any provincial taxes, levies,
duties or surcharges; or'),
('1d', 120, 'authorises direct charges against a Provincial Revenue Fund.'),
('2', 120, 'A money Bill may not deal with any other matter except—'),
('2a', 120, 'a subordinate matter incidental to the appropriation of money;'),
('2b', 120, 'the imposition, abolition or reduction of provincial taxes, levies, duties or
surcharges;'),
('2c', 120, 'the granting of exemption from provincial taxes, levies, duties or surcharges; or'),
('2d', 120, 'the authorisation of direct charges against a Provincial Revenue Fund.'),
('3', 120, 'A provincial Act must provide for a procedure by which the province’s legislature
may amend a money Bill.'),

('1', 121, 'The Premier of a province must either assent to and sign a Bill passed by the
provincial legislature in terms of this Chapter or, if the Premier has reservations
about the constitutionality of the Bill, refer it back to the legislature for
reconsideration.'),
('2', 121, 'If, after reconsideration, a Bill fully accommodates the Premier’s reservations, the
Premier must assent to and sign the Bill; if not, the Premier must either—'),
('2a', 121, 'assent to and sign the Bill; or'),
('2b', 121, 'refer it to the Constitutional Court for a decision on its constitutionality.'),
('3', 121, 'If the Constitutional Court decides that the Bill is constitutional, the Premier must
assent to and sign it.'),

('1', 122, 'Members of a provincial legislature may apply to the Constitutional Court for an
order declaring that all or part of a provincial Act is unconstitutional.'),
('2', 122, 'An application—'),
('2a', 122, 'must be supported by at least 20 per cent of the members of the legislature;
and'),
('2b', 122, 'must be made within 30 days of the date on which the Premier assented to
and signed the Act.'),
('3', 122, 'The Constitutional Court may order that all or part of an Act that is the subject of an
application in terms of subsection (1) has no force until the Court has decided the
application if—'),
('3a', 122, 'the interests of justice require this; and'),
('3b', 122, 'the application has a reasonable prospect of success.'),
('4', 122, 'If an application is unsuccessful, and did not have a reasonable prospect of success,
the Constitutional Court may order the applicants to pay costs.'),

('1', 125, 'The executive authority of a province is vested in the Premier of that province.'),
('2', 125, 'The Premier exercises the executive authority, together with the other members of
the Executive Council, by—'),
('2a', 125, 'implementing provincial legislation in the province;'),
('2b', 125, 'implementing all national legislation within the functional areas listed in
Schedule 4 or 5 except where the Constitution or an Act of Parliament provides
otherwise;'),
('2c', 125, 'administering in the province, national legislation outside the functional areas
listed in Schedules 4 and 5, the administration of which has been assigned to
the provincial executive in terms of an Act of Parliament;'),
('2d', 125, 'developing and implementing provincial policy;'),
('2e', 125, 'co-ordinating the functions of the provincial administration and its
departments;'),
('2f', 125, 'preparing and initiating provincial legislation; and'),
('2g', 125, 'performing any other function assigned to the provincial executive in terms of
the Constitution or an Act of Parliament.'),
('3', 125, 'A province has executive authority in terms of subsection (2)(b) only to the extent
that the province has the administrative capacity to assume effective responsibility.
The national government, by legislative and other measures, must assist provinces
to develop the administrative capacity required for the effective exercise of their
powers and performance of their functions referred to in subsection (2).'),
('4', 125, 'Any dispute concerning the administrative capacity of a province in regard to any
function must be referred to the National Council of Provinces for resolution within
30 days of the date of the referral to the Council.'),
('5', 125, 'Subject to section 100, the implementation of provincial legislation in a province is
an exclusive provincial executive power.'),
('6', 125, 'The provincial executive must act in accordance with—'),
('6a', 125, 'the Constitution; and'),
('6b', 125, 'the provincial constitution, if a constitution has been passed for the province.'),

('0', 126, 'A member of the Executive Council of a province may assign any power or function that
is to be exercised or performed in terms of an Act of Parliament or a provincial Act, to a
Municipal Council. An assignment—'),
('0a', 126, 'must be in terms of an agreement between the relevant Executive Council
member and the Municipal Council;'),
('0b', 126, 'must be consistent with the Act in terms of which the relevant power or
function is exercised or performed; and'),
('0c', 126, 'takes effect upon proclamation by the Premier.'),

('1', 127, 'The Premier of a province has the powers and functions entrusted to that office by
the Constitution and any legislation.'),
('2', 127, 'The Premier of a province is responsible for—'),
('2a', 127, 'assenting to and signing Bills;'),
('2b', 127, 'referring a Bill back to the provincial legislature for reconsideration of the Bill’s
constitutionality;'),
('2c', 127, 'referring a Bill to the Constitutional Court for a decision on the Bill’s
constitutionality;'),
('2d', 127, 'summoning the legislature to an extraordinary sitting to conduct special
business;'),
('2e', 127, 'appointing commissions of inquiry; and'),
('2f', 127, 'calling a referendum in the province in accordance with national legislation.'),

('1', 128, 'At its first sitting after its election, and whenever necessary to fill a vacancy, a
provincial legislature must elect a woman or a man from among its members to be
the Premier of the province.'),
('2', 128, 'A judge designated by the Chief Justice must preside over the election of the
Premier. The procedure set out in Part A of Schedule 3 applies to the election of the
Premier.'),
('3', 128, 'An election to fill a vacancy in the office of Premier must be held at a time and on
a date determined by the Chief Justice, but not later than 30 days after the vacancy
occurs.'),

('1', 130, 'A Premier’s term of office begins when the Premier assumes office and ends upon a
vacancy occurring or when the person next elected Premier assumes office.'),
('2', 130, 'No person may hold office as Premier for more than two terms, but when a person
is elected to fill a vacancy in the office of Premier, the period between that election
and the next election of a Premier is not regarded as a term.'),
('3', 130, 'The legislature of a province, by a resolution adopted with a supporting vote of at
least two thirds of its members, may remove the Premier from office only on the
grounds of—'),
('3a', 130, 'a serious violation of the Constitution or the law;'),
('3b', 130, 'serious misconduct; or'),
('3c', 130, 'inability to perform the functions of office.'),
('4', 130, 'Anyone who has been removed from the office of Premier in terms of subsection (3)
(a) or (b) may not receive any benefits of that office, and may not serve in any public
office.'),

('1', 131, 'When the Premier is absent or otherwise unable to fulfil the duties of the office of
Premier, or during a vacancy in the office of Premier, an office-bearer in the order
below acts as the Premier:'),
('1a', 131, 'A member of the Executive Council designated by the Premier.'),
('1b', 131, 'A member of the Executive Council designated by the other members of the
Council.'),
('1c', 131, 'The Speaker, until the legislature designates one of its other members.'),
('2', 131, 'An Acting Premier has the responsibilities, powers and functions of the Premier.'),
('3', 131, 'Before assuming the responsibilities, powers and functions of the Premier, the
Acting Premier must swear or affirm faithfulness to the Republic and obedience to
the Constitution, in accordance with Schedule 2.'),

('1', 132, 'The Executive Council of a province consists of the Premier, as head of the Council,
and no fewer than five and no more than ten members appointed by the Premier
from among the members of the provincial legislature.'),
('2', 132, 'The Premier of a province appoints the members of the Executive Council, assigns
their powers and functions, and may dismiss them.'),

('1', 133, 'The members of the Executive Council of a province are responsible for the functions
of the executive assigned to them by the Premier.'),
('2', 133, 'Members of the Executive Council of a province are accountable collectively and
individually to the legislature for the exercise of their powers and the performance
of their functions.'),
('3', 133, 'Members of the Executive Council of a province must—'),
('3a', 133, 'act in accordance with the Constitution and, if a provincial constitution has
been passed for the province, also that constitution; and'),
('3b', 133, 'provide the legislature with full and regular reports concerning matters under
their control.'),

('1', 136, 'Members of the Executive Council of a province must act in accordance with a code
of ethics prescribed by national legislation.'),
('2', 136, 'Members of the Executive Council of a province may not—'),
('2a', 136, 'undertake any other paid work;'),
('2b', 136, 'act in any way that is inconsistent with their office, or expose themselves
to any situation involving the risk of a conflict between their official
responsibilities and private interests; or'),
('2c', 136, 'use their position or any information entrusted to them, to enrich themselves
or improperly benefit any other person.'),

('0', 137, 'The Premier by proclamation may transfer to a member of the Executive Council—'),
('0a', 137, 'the administration of any legislation entrusted to another member; or'),
('0b', 137, 'any power or function entrusted by legislation to another member.'),

('1', 139, 'When a municipality cannot or does not fulfil an executive obligation in terms of the
Constitution or legislation, the relevant provincial executive may intervene by taking
any appropriate steps to ensure fulfilment of that obligation, including—'),
('1a', 139, 'issuing a directive to the Municipal Council, describing the extent of the failure
to fulfil its obligations and stating any steps required to meet its obligations;'),
('1b', 139, 'assuming responsibility for the relevant obligation in that municipality to the
extent necessary to —'),
('1c', 139, 'dissolving the Municipal Council and appointing an administrator until a
newly elected Municipal Council has been declared elected, if exceptional
circumstances warrant such a step.'),
('2', 139, 'If a provincial executive intervenes in a municipality in terms of subsection (1)(b)—'),
('2a', 139, 'it must submit a written notice of the intervention to—'),
('2b', 139, 'the intervention must end if—'),
('2c', 139, 'the Council must, while the intervention continues, review the intervention
regularly and may make any appropriate recommendations to the provincial
executive.'),
('3', 139, 'If a Municipal Council is dissolved in terms of subsection (1)(c)—'),
('3a', 139, 'the provincial executive must immediately submit a written notice of the
dissolution to—'),
('3b', 139, 'the dissolution takes effect 14 days from the date of receipt of the notice by
the Council unless set aside by that Cabinet member or the Council before the
expiry of those 14 days.'),
('4', 139, 'If a municipality cannot or does not fulfil an obligation in terms of the Constitution
or legislation to approve a budget or any revenue-raising measures necessary to
give effect to the budget, the relevant provincial executive must intervene by taking
any appropriate steps to ensure that the budget or those revenue-raising measures
are approved, including dissolving the Municipal Council and—'),
('4a', 139, 'appointing an administrator until a newly elected Municipal Council has been
declared elected; and'),
('4b', 139, 'approving a temporary budget or revenue-raising measures to provide for the
continued functioning of the municipality.'),
('5', 139, 'If a municipality, as a result of a crisis in its financial affairs, is in serious or persistent
material breach of its obligations to provide basic services or to meet its financial
commitments, or admits that it is unable to meet its obligations or financial
commitments, the relevant provincial executive must—'),
('5a', 139, 'impose a recovery plan aimed at securing the municipality’s ability to meet its
obligations to provide basic services or its financial commitments, which—'),
('5b', 139, 'dissolve the Municipal Council, if the municipality cannot or does not approve
legislative measures, including a budget or any revenue-raising measures,
necessary to give effect to the recovery plan, and—'),
('5c', 139, 'if the Municipal Council is not dissolved in terms of paragraph (b), assume
responsibility for the implementation of the recovery plan to the extent that
the municipality cannot or does not otherwise implement the recovery plan.'),
('6', 139, 'If a provincial executive intervenes in a municipality in terms of subsection (4) or
(5), it must submit a written notice of the intervention to—'),
('6a', 139, 'the Cabinet member responsible for local government affairs; and'),
('6b', 139, 'the relevant provincial legislature and the National Council of Provinces, within
seven days after the intervention began.'),
('7', 139, 'If a provincial executive cannot or does not or does not adequately exercise the
powers or perform the functions referred to in subsection (4) or (5), the national
executive must intervene in terms of subsection (4) or (5) in the stead of the
relevant provincial executive.'),
('8', 139, 'National legislation may regulate the implementation of this section, including the
processes established by this section.'),

('1', 140, 'A decision by the Premier of a province must be in writing if it—'),
('1a', 140, 'is taken in terms of legislation; or'),
('1b', 140, 'has legal consequences.'),
('2', 140, 'A written decision by the Premier must be countersigned by another Executive
Council member if that decision concerns a function assigned to that other member.'),
('3', 140, 'Proclamations, regulations and other instruments of subordinate legislation of a
province must be accessible to the public.'),
('4', 140, 'Provincial legislation may specify the manner in which, and the extent to which,
instruments mentioned in subsection (3) must be—'),
('4a', 140, 'tabled in the provincial legislature; and'),
('4b', 140, 'approved by the provincial legislature.'),

('1', 141, 'If a provincial legislature, by a vote supported by a majority of its members, passes
a motion of no confidence in the province’s Executive Council excluding the Premier,
the Premier must reconstitute the Council.'),
('2', 141, 'If a provincial legislature, by a vote supported by a majority of its members, passes a
motion of no confidence in the Premier, the Premier and the other members of the
Executive Council must resign.'),

('1', 143, 'A provincial constitution, or constitutional amendment, must not be inconsistent
with this Constitution, but may provide for—'),
('1a', 143, 'provincial legislative or executive structures and procedures that differ from
those provided for in this Chapter; or'),
('1b', 143, 'the institution, role, authority and status of a traditional monarch,
where applicable.'),
('2', 143, 'Provisions included in a provincial constitution or constitutional amendment in
terms of paragraphs (a) or (b) of subsection (1)—'),
('2a', 143, 'must comply with the values in section 1 and with Chapter 3; and'),
('2b', 143, 'may not confer on the province any power or function that falls—'),

('1', 144, 'If a provincial legislature has passed or amended a constitution, the Speaker of the
legislature must submit the text of the constitution or constitutional amendment to
the Constitutional Court for certification.'),
('2', 144, 'No text of a provincial constitution or constitutional amendment becomes law until
the Constitutional Court has certified—'),
('2a', 144, 'that the text has been passed in accordance with section 142; and'),
('2b', 144, 'that the whole text complies with section 143.'),

('1', 145, 'The Premier of a province must assent to and sign the text of a provincial
constitution or constitutional amendment that has been certified by the
Constitutional Court.'),
('2', 145, 'The text assented to and signed by the Premier must be published in the national
Government Gazette and takes effect on publication or on a later date determined in
terms of that constitution or amendment.'),
('3', 145, 'The signed text of a provincial constitution or constitutional amendment is
conclusive evidence of its provisions and, after publication, must be entrusted to the
Constitutional Court for safekeeping.'),

('1', 146, 'This section applies to a conflict between national legislation and provincial
legislation falling within a functional area listed in Schedule 4.'),
('2', 146, 'National legislation that applies uniformly with regard to the country as a whole
prevails over provincial legislation if any of the following conditions is met:'),
('2a', 146, 'The national legislation deals with a matter that cannot be regulated
effectively by legislation enacted by the respective provinces individually.'),
('2b', 146, 'The national legislation deals with a matter that, to be dealt with effectively,
requires uniformity across the nation, and the national legislation provides
that uniformity by establishing—'),
('2c', 146, 'The national legislation is necessary for—'),
('3', 146, 'National legislation prevails over provincial legislation if the national legislation is
aimed at preventing unreasonable action by a province that—'),
('3a', 146, 'is prejudicial to the economic, health or security interests of another province
or the country as a whole; or'),
('3b', 146, 'impedes the implementation of national economic policy.'),
('4', 146, 'When there is a dispute concerning whether national legislation is necessary for
a purpose set out in subsection (2)(c) and that dispute comes before a court for
resolution, the court must have due regard to the approval or the rejection of the
legislation by the National Council of Provinces.'),
('5', 146, 'Provincial legislation prevails over national legislation if subsection (2) or (3) does
not apply.'),
('6', 146, 'A law made in terms of an Act of Parliament or a provincial Act can prevail only if
that law has been approved by the National Council of Provinces.'),
('7', 146, 'If the National Council of Provinces does not reach a decision within 30 days of
its first sitting after a law was referred to it, that law must be considered for all
purposes to have been approved by the Council.'),
('8', 146, 'If the National Council of Provinces does not approve a law referred to in subsection
(6), it must, within 30 days of its decision, forward reasons for not approving the
law to the authority that referred the law to it.'),

('1', 147, 'If there is a conflict between national legislation and a provision of a provincial
constitution with regard to—'),
('1a', 147, 'a matter concerning which this Constitution specifically requires
or envisages the enactment of national legislation, the national legislation
prevails over the affected provision of the provincial constitution;'),
('1b', 147, 'national legislative intervention in terms of section 44 (2), the national
legislation prevails over the provision of the provincial constitution; or'),
('1c', 147, 'a matter within a functional area listed in Schedule 4, section 146 applies as if
the affected provision of the provincial constitution were provincial legislation
referred to in that section.'),
('2', 147, 'National legislation referred to in section 44(2) prevails over provincial legislation in
respect of matters within the functional areas listed in Schedule 5.');
GO

INSERT INTO [MainSchema].Clauses(ClauseID, SectionID, SubsectionID, ClauseText)
VALUES
('i', 104, '1b', 'any matter within a functional area listed in Schedule 4;'),
('ii', 104, '1b', 'any matter within a functional area listed in Schedule 5;'),
('iii', 104, '1b', 'any matter outside those functional areas, and that is expressly assigned
to the province by national legislation; and'),
('iv', 104, '1b', 'any matter for which a provision of the Constitution envisages the
enactment of provincial legislation; and'),

('i', 106, '1a', 'the Premier and other members of the Executive Council of a province;
and'),
('ii', 106, '1a', 'other office-bearers whose functions are compatible with the functions
of a member of a provincial legislature, and have been declared
compatible with those functions by national legislation;'),

('i', 114, '2b', 'the exercise of provincial executive authority in the province, including
the implementation of legislation; and'),
('ii', 114, '2b', 'any provincial organ of state.'),

('i', 117, '1b', 'anything that they have said in, produced before or submitted to the
legislature or any of its committees; or'),
('ii', 117, '1b', 'anything revealed as a result of anything that they have said in,
produced before or submitted to the legislature or any of its committees.'),

('i', 118, '1b', 'to regulate public access, including access of the media, to the legislature
and its committees; and'),
('ii', 118, '1b', 'to provide for the searching of any person and, where appropriate, the
refusal of entry to, or the removal of, any person.'),

('i', 139, '1b', 'maintain essential national standards or meet established minimum
standards for the rendering of a service;'),
('ii', 139, '1b', 'prevent that Municipal Council from taking unreasonable action that is
prejudicial to the interests of another municipality or to the province as a
whole; or'),
('iii', 139, '1b', 'maintain economic unity; or'),
('i', 139, '2a', 'the Cabinet member responsible for local government affairs; and'),
('ii', 139, '2a', 'the relevant provincial legislature and the National Council of Provinces,
within 14 days after the intervention began;'),
('i', 139, '2b', 'the Cabinet member responsible for local government affairs disapproves
the intervention within 28 days after the intervention began or by the
end of that period has not approved the intervention; or'),
('ii', 139, '2b', 'the Council disapproves the intervention within 180 days after the
intervention began or by the end of that period has not approved the
intervention; and'),
('i', 139, '3a', 'the Cabinet member responsible for local government affairs; and'),
('ii', 139, '3a', 'the relevant provincial legislature and the National Council of Provinces;
and'),
('i', 139, '5a', 'is to be prepared in accordance with national legislation; and'),
('ii', 139, '5a', 'binds the municipality in the exercise of its legislative and executive
authority, but only to the extent necessary to solve the crisis in its
financial affairs; and'),
('i', 139, '5b', 'appoint an administrator until a newly elected Municipal Council has
been declared elected; and'),
('ii', 139, '5b', 'approve a temporary budget or revenue-raising measures or any other
measures giving effect to the recovery plan to provide for the continued
functioning of the municipality; or'),

('i', 143, '2b', 'outside the area of provincial competence in terms of Schedules 4 and 5;
or'),
('ii', 143, '2b', 'outside the powers and functions conferred on the province by other
sections of the Constitution.'),

('i', 146, '2b', 'norms and standards;r'),
('ii', 146, '2b', 'frameworks; or'),
('iii', 146, '2b', 'national policies.'),
('i', 146, '2c', 'the maintenance of national security;'),
('ii', 146, '2c', 'the maintenance of economic unity;'),
('iii', 146, '2c', 'the protection of the common market in respect of the mobility of goods,
services, capital and labour;'),
('iv', 146, '2c', 'the promotion of economic activities across provincial boundaries;'),
('v', 146, '2c', 'the promotion of equal opportunity or equal access to government
services; or'),
('vi', 146, '2c', 'the protection of the environment.');
GO


/* /////////////// Chapter 7's contents /////////// */
INSERT INTO [MainSchema].Sections (SectionID, ChapterID, SectionTitle, SectionText)
VALUES
(151, 7, 'Status of municipalities', NULL),
(152, 7, 'Objects of local government', NULL),
(153, 7, 'Developmental duties of municipalities',	NULL),
(154, 7, 'Municipalities in co-operative government', NULL),
(155, 7, 'Establishment of municipalities', NULL),
(156, 7, 'Powers and functions of municipalities', NULL),
(157, 7, 'Composition and election of Municipal Councils', NULL),
(158, 7, 'Membership of Municipal Councils', NULL),
(159, 7, 'Terms of Municipal Councils', NULL),
(160, 7, 'Internal procedures', NULL),
(161, 7, 'Privilege', 'Provincial legislation within the framework of national legislation may provide for
privileges and immunities of Municipal Councils and their members.'),
(162, 7, 'Publication of municipal by-laws', NULL),
(163, 7, 'Organised local government', NULL),
(164, 7, 'Other matters', 'Any matter concerning local government not dealt with in the Constitution may be
prescribed by national legislation or by provincial legislation within the framework of
national legislation.');

INSERT INTO [MainSchema].Subsections(SubsectionID, SectionID, SubsectionText)
VALUES
('1', 151, 'The local sphere of government consists of municipalities, which must be
established for the whole of the territory of the Republic.'),
('2', 151, 'The executive and legislative authority of a municipality is vested in its Municipal
Council.'),
('3', 151, 'A municipality has the right to govern, on its own initiative, the local
government affairs of its community, subject to national and provincial legislation,
as provided for in the Constitution.'),
('4', 151, 'The national or a provincial government may not compromise or impede a
municipality’s ability or right to exercise its powers or perform its functions.'),

('1', 152, 'The objects of local government are—'),
('1a', 152, 'to provide democratic and accountable government for local communities;'),
('1b', 152, 'to ensure the provision of services to communities in a sustainable manner;'),
('1c', 152, 'to promote social and economic development;'),
('1d', 152, 'to promote a safe and healthy environment; and'),
('1e', 152, 'to encourage the involvement of communities and community organisations
in the matters of local government.'),
('2', 152, 'A municipality must strive, within its financial and administrative capacity, to
achieve the objects set out in subsection (1).'),

('0', 153, 'A municipality must—'),
('0a', 153, 'structure and manage its administration and budgeting and planning
processes to give priority to the basic needs of the community, and to promote
the social and economic development of the community; and'),
('0b', 153, 'participate in national and provincial development programmes.'),

('1', 154, 'The national government and provincial governments, by legislative and other
measures, must support and strengthen the capacity of municipalities to manage
their own affairs, to exercise their powers and to perform their functions.'),
('2', 154, 'Draft national or provincial legislation that affects the status, institutions, powers
or functions of local government must be published for public comment before
it is introduced in Parliament or a provincial legislature, in a manner that allows
organised local government, municipalities and other interested persons an
opportunity to make representations with regard to the draft legislation.'),

('1', 155, 'There are the following categories of municipality:'),
('1a', 155, 'Category A: A municipality that has exclusive municipal executive and
legislative authority in its area.'),
('1b', 155, 'Category B: A municipality that shares municipal executive and legislative
authority in its area with a category C municipality within whose area it falls.'),
('1c', 155, 'Category C: A municipality that has municipal executive and legislative
authority in an area that includes more than one municipality.'),
('2', 155, 'National legislation must define the different types of municipality that may be
established within each category.'),
('3', 155, 'National legislation must—'),
('3a', 155, 'establish the criteria for determining when an area should have a single
category A municipality or when it should have municipalities of both category
B and category C;'),
('3b', 155, 'establish criteria and procedures for the determination of municipal
boundaries by an independent authority; and'),
('3c', 155, 'subject to section 229, make provision for an appropriate division of powers
and functions between municipalities when an area has municipalities of
both category B and category C. A division of powers and functions between
a category B municipality and a category C municipality may differ from the
division of powers and functions between another category B municipality and
that category C municipality.'),
('4', 155, 'The legislation referred to in subsection (3) must take into account the need to
provide municipal services in an equitable and sustainable manner.'),
('5', 155, 'Provincial legislation must determine the different types of municipality to be
established in the province.'),
('6', 155, 'Each provincial government must establish municipalities in its province in a
manner consistent with the legislation enacted in terms of subsections (2) and (3)
and, by legislative or other measures, must—'),
('6a', 155, 'provide for the monitoring and support of local government in the province;
and'),
('6b', 155, 'promote the development of local government capacity to enable
municipalities to perform their functions and manage their own affairs.'),
('6A_d', 155, 'Deleted by s. 2 of the Constitution Twelfth Amendment Act of 2005.'),
('7', 155, 'The national government, subject to section 44, and the provincial governments
have the legislative and executive authority to see to the effective performance by
municipalities of their functions in respect of matters listed in Schedules 4 and 5, by
regulating the exercise by municipalities of their executive authority referred to in
section 156(1).'),

('1', 156, 'A municipality has executive authority in respect of, and has the right to
administer—'),
('1a', 156, 'the local government matters listed in Part B of Schedule 4 and Part B of
Schedule 5; and'),
('1b', 156, 'any other matter assigned to it by national or provincial legislation.'),
('2', 156, 'A municipality may make and administer by-laws for the effective administration of
the matters which it has the right to administer.'),
('3', 156, 'Subject to section 151(4), a by-law that conflicts with national or provincial
legislation is invalid. If there is a conflict between a bylaw and national or provincial
legislation that is inoperative because of a conflict referred to in section 149, the
by-law must be regarded as valid for as long as that legislation is inoperative.'),
('4', 156, 'The national government and provincial governments must assign to a municipality,
by agreement and subject to any conditions, the administration of a matter listed
in Part A of Schedule 4 or Part A of Schedule 5 which necessarily relates to local
government, if—'),
('4a', 156, 'that matter would most effectively be administered locally; and'),
('4b', 156, 'the municipality has the capacity to administer it.'),
('5', 156, 'A municipality has the right to exercise any power concerning a matter reasonably
necessary for, or incidental to, the effective performance of its functions.'),

('1', 157, 'A Municipal Council consists of—'),
('1a', 157, 'members elected in accordance with subsections (2) and (3); or'),
('1b', 157, 'if provided for by national legislation—'),
('2', 157, 'The election of members to a Municipal Council as anticipated in subsection (1)(a)
must be in accordance with national legislation, which must prescribe a system—'),
('2a', 157, 'of proportional representation based on that municipality’s segment of the
national common voters roll, and which provides for the election of members
from lists of party candidates drawn up in a party’s order of preference; or'),
('2b', 157, 'of proportional representation as described in paragraph (a) combined with
a system of ward representation based on that municipality’s segment of the
national common voters roll.'),
('3', 157, 'An electoral system in terms of subsection (2) must result, in general, in
proportional representation.'),
('4a', 157, 'If the electoral system includes ward representation, the delimitation of
wards must be done by an independent authority appointed in terms of,
and operating according to, procedures and criteria prescribed by national
legislation.'),
('4b', 157, 'Deleted by s. 3 of the Constitution Twelfth Amendment Act of 2005.'),
('5', 157, 'A person may vote in a municipality only if that person is registered on that
municipality’s segment of the national common voters roll.'),
('6', 157, 'The national legislation referred to in subsection (1)(b) must establish a system
that allows for parties and interests reflected within the Municipal Council making
the appointment, to be fairly represented in the Municipal Council to which the
appointment is made.'),

('1', 158, 'Every citizen who is qualified to vote for a Municipal Council is eligible to be a
member of that Council, except—'),
('1a', 158, 'anyone who is appointed by, or is in the service of, the municipality and
receives remuneration for that appointment or service, and who has not been
exempted from this disqualification in terms of national legislation;'),
('1b', 158, 'anyone who is appointed by, or is in the service of, the state in another sphere,
and receives remuneration for that appointment or service, and who has been
disqualified from membership of a Municipal Council in terms of national
legislation;'),
('1c', 158, 'anyone who is disqualified from voting for the National Assembly or is
disqualified in terms of section 47(1)(c), (d) or (e) from being a member of the
Assembly;'),
('1d', 158, 'a member of the National Assembly, a delegate to the National Council of
Provinces or a member of a provincial legislature; but this disqualification does
not apply to a member of a Municipal Council representing local government
in the National Council; or'),
('1e', 158, 'a member of another Municipal Council; but this disqualification
does not apply to a member of a Municipal Council representing that Council in
another Municipal Council of a different category.'),
('2', 158, 'A person who is not eligible to be a member of a Municipal Council in terms of
subsection (1)(a), (b), (d) or (e) may be a candidate for the Council, subject to any
limits or conditions established by national legislation.'),
('3', 158, 'Vacancies in a Municipal Council must be filled in terms of national legislation.'),

('1', 159, 'The term of a Municipal Council may be no more than five years, as
determined by national legislation.'),
('2', 159, 'If a Municipal Council is dissolved in terms of national legislation, or when its
term expires, an election must be held within 90 days of the date that Council was
dissolved or its term expired.'),
('3', 159, 'A Municipal Council, other than a Council that has been dissolved following an
intervention in terms of section 139, remains competent to function from the time
it is dissolved or its term expires, until the newly elected Council has been declared
elected.'),

('1', 160, 'A Municipal Council—'),
('1a', 160, 'makes decisions concerning the exercise of all the powers and the performance
of all the functions of the municipality;'),
('1b', 160, 'must elect its chairperson;'),
('1c', 160, 'may elect an executive committee and other committees, subject to national
legislation; and'),
('1d', 160, 'may employ personnel that are necessary for the effective performance of its
functions.'),
('2', 160, 'The following functions may not be delegated by a Municipal Council:'),
('2a', 160, 'The passing of by-laws;'),
('2b', 160, 'the approval of budgets;'),
('2c', 160, 'the imposition of rates and other taxes, levies and duties; and'),
('2d', 160, 'the raising of loans.'),
('3a', 160, 'A majority of the members of a Municipal Council must be present before a
vote may be taken on any matter.'),
('3b', 160, 'All questions concerning matters mentioned in subsection (2) are determined
by a decision taken by a Municipal Council with a supporting vote of a majority
of its members.'),
('3c', 160, 'All other questions before a Municipal Council are decided by a majority of the
votes cast.'),
('4', 160, 'No by-law may be passed by a Municipal Council unless—'),
('4a', 160, 'all the members of the Council have been given reasonable notice; and'),
('4b', 160, 'the proposed by-law has been published for public comment.'),
('5', 160, 'National legislation may provide criteria for determining—'),
('5a', 160, 'the size of a Municipal Council;'),
('5b', 160, 'whether Municipal Councils may elect an executive committee or any other
committee; or'),
('5c', 160, 'the size of the executive committee or any other committee of a Municipal
Council.'),
('6', 160, 'A Municipal Council may make by-laws which prescribe rules and orders for—'),
('6a', 160, 'its internal arrangements;'),
('6b', 160, 'its business and proceedings; and'),
('6c', 160, 'the establishment, composition, procedures, powers and functions of its
committees.'),
('7', 160, 'A Municipal Council must conduct its business in an open manner, and may close
its sittings, or those of its committees, only when it is reasonable to do so having
regard to the nature of the business being transacted.'),
('8', 160, 'Members of a Municipal Council are entitled to participate in its proceedings and
those of its committees in a manner that—'),
('8a', 160, 'allows parties and interests reflected within the Council to be fairly
represented;'),
('8b', 160, 'is consistent with democracy; and'),
('8c', 160, 'may be regulated by national legislation.'),

('1', 162, 'A municipal by-law may be enforced only after it has been published in the official
gazette of the relevant province.'),
('2', 162, 'A provincial official gazette must publish a municipal by-law upon request by the
municipality.'),
('3', 162, 'Municipal by-laws must be accessible to the public.'),

('0', 163, 'An Act of Parliament enacted in accordance with the procedure established by section 76
must—'),
('0a', 163, 'provide for the recognition of national and provincial organisations
representing municipalities; and'),
('0b', 163, 'determine procedures by which local government may—');
GO

INSERT INTO [MainSchema].Clauses(ClauseID, SectionID, SubsectionID, ClauseText)
VALUES
('i', 157, '1b', 'members appointed by other Municipal Councils to represent those other
Councils; or'),
('ii', 157, '1b', 'both members elected in accordance with paragraph (a) and members
appointed in accordance with subparagraph (i) of this paragraph.'),

('i', 163, '0b', 'consult with the national or a provincial government;'),
('ii', 163, '0b', 'designate representatives to participate in the National Council of
Provinces; and'),
('iii', 163, '0b', 'participate in the process prescribed in the national legislation envisaged
in section 221(1)(c).');
GO


/* /////////////// Chapter 8's contents /////////// */
INSERT INTO [MainSchema].Sections (SectionID, ChapterID, SectionTitle, SectionText)
VALUES
(165, 8, 'Judicial authority', NULL),
(166, 8, 'Judicial system', NULL),
(167, 8, 'Constitutional Court', NULL),
(168, 8, 'Supreme Court of Appeal', NULL),
(169, 8, 'High Court of South Africa', NULL),
(170, 8, 'Other courts', 'All courts other than those referred to in sections 167, 168 and 169 may decide any matter
determined by an Act of Parliament, but a court of a status lower than the High Court of
South Africa may not enquire into or rule on the constitutionality of any legislation or any
conduct of the President.'),
(171, 8, 'Court procedures', 'All courts function in terms of national legislation, and their rules and procedures must be
provided for in terms of national legislation.'),
(172, 8, 'Powers of courts in constitutional matters', NULL),
(173, 8, 'Inherent power', 'The Constitutional Court, the Supreme Court of Appeal and the High Court of South Africa
each has the inherent power to protect and regulate their own process, and to develop the
common law, taking into account the interests of justice.'),
(174, 8, 'Appointment of judicial officers', NULL),
(175, 8, 'Appointment of acting judges', NULL),
(176, 8, 'Terms of office and remuneration', NULL),
(177, 8, 'Removal', NULL),
(178, 8, 'Judicial Service Commission', NULL),
(179, 8, 'Prosecuting authority', NULL),
(180, 8, 'Other matters concerning administration of justice', NULL);

INSERT INTO [MainSchema].Subsections(SubsectionID, SectionID, SubsectionText)
VALUES
('1', 165, 'The judicial authority of the Republic is vested in the courts.'),
('2', 165, 'The courts are independent and subject only to the Constitution and the law, which
they must apply impartially and without fear, favour or prejudice.'),
('3', 165, 'No person or organ of state may interfere with the functioning of the
courts.'),
('4', 165, 'Organs of state, through legislative and other measures, must assist and protect
the courts to ensure the independence, impartiality, dignity, accessibility and
effectiveness of the courts.'),
('5', 165, 'An order or decision issued by a court binds all persons to whom and organs of state
to which it applies.'),
('6', 165, 'The Chief Justice is the head of the judiciary and exercises responsibility over the
establishment and monitoring of norms and standards for the exercise of the
judicial functions of all courts.'),

('0', 166, 'The courts are—'),
('0a', 166, 'the Constitutional Court;'),
('0b', 166, 'the Supreme Court of Appeal;'),
('0c', 166, 'the High Court of South Africa, and any high court of appeal that may be
established by an Act of Parliament to hear appeals from any court of a status
similar to the High Court of South Africa;'),
('0d', 166, 'the Magistrates’ Courts; and'),
('0e', 166, 'any other court established or recognised in terms of an Act of Parliament,
including any court of a status similar to either the High Court of South Africa
or the Magistrates’ Courts.'),

('1', 167, 'The Constitutional Court consists of the Chief Justice of South Africa, the Deputy
Chief Justice and nine other judges.'),
('2', 167, 'A matter before the Constitutional Court must be heard by at least eight judges.'),
('3', 167, 'The Constitutional Court—'),
('3a', 167, 'is the highest court of the Republic; and'),
('3b', 167, 'may decide—'),
('3c', 167, 'makes the final decision whether a matter is within its jurisdiction.'),
('4', 167, 'Only the Constitutional Court may—'),
('4a', 167, 'decide disputes between organs of state in the national or provincial
sphere concerning the constitutional status, powers or functions of any of
those organs of state;'),
('4b', 167, 'decide on the constitutionality of any parliamentary or provincial Bill, but may
do so only in the circumstances anticipated in section 79 or 121;'),
('4c', 167, 'decide applications envisaged in section 80 or 122;'),
('4d', 167, 'decide on the constitutionality of any amendment to the Constitution;'),
('4e', 167, 'decide that Parliament or the President has failed to fulfil a constitutional
obligation; or'),
('4f', 167, 'certify a provincial constitution in terms of section 144.'),
('5', 167, 'The Constitutional Court makes the final decision whether an Act of Parliament, a
provincial Act or conduct of the President is constitutional, and must confirm any
order of invalidity made by the Supreme Court of Appeal, the High Court of South
Africa, or a court of similar status, before that order has any force.'),
('6', 167, 'National legislation or the rules of the Constitutional Court must allow a person,
when it is in the interests of justice and with leave of the Constitutional Court—'),
('6a', 167, 'to bring a matter directly to the Constitutional Court; or'),
('6b', 167, 'to appeal directly to the Constitutional Court from any other court.'),
('7', 167, 'A constitutional matter includes any issue involving the interpretation, protection or
enforcement of the Constitution.'),

('1', 168, 'The Supreme Court of Appeal consists of a President, a Deputy President and the
number of judges of appeal determined in terms of an Act of Parliament.'),
('2', 168, 'A matter before the Supreme Court of Appeal must be decided by the number of
judges determined in terms of an Act of Parliament.'),
('3a', 168, 'The Supreme Court of Appeal may decide appeals in any matter arising from
the High Court of South Africa or a court of a status similar to the High Court
of South Africa, except in respect of labour or competition matters to such an
extent as may be determined by an Act of Parliament.'),
('3b', 168, 'The Supreme Court of Appeal may decide only—'),

('1', 169, 'The High Court of South Africa may decide—'),
('1a', 169, 'any constitutional matter except a matter that—'),
('1b', 169, 'any other matter not assigned to another court by an Act of Parliament.'),
('2', 169, 'The High Court of South Africa consists of the Divisions determined by an Act of
Parliament, which Act must provide for—'),
('2a', 169, 'the establishing of Divisions, with one or two more seats in a Division; and'),
('2b', 169, 'the assigning of jurisdiction to a Division or a seat with a Division.'),
('3', 169, 'Each Division of the High Court of South Africa—'),
('3a', 169, 'has a Judge President;'),
('3b', 169, 'may have one or more Deputy Judges President; and'),
('3c', 169, 'has the number of other judges determined in terms of national legislation.'),

('1', 172, 'When deciding a constitutional matter within its power, a court—'),
('1a', 172, 'must declare that any law or conduct that is inconsistent with the Constitution
is invalid to the extent of its inconsistency; and'),
('1b', 172, 'may make any order that is just and equitable, including—'),
('2a', 172, 'The Supreme Court of Appeal, the High Court of South Africa or a court of
similar status may make an order concerning the constitutional validity of
an Act of Parliament, a provincial Act or any conduct of the President, but an
order of constitutional invalidity has no force unless it is confirmed by the
Constitutional Court.'),
('2b', 172, 'A court which makes an order of constitutional invalidity may grant a
temporary interdict or other temporary relief to a party, or may adjourn the
proceedings, pending a decision of the Constitutional Court on the validity of
that Act or conduct.'),
('2c', 172, 'National legislation must provide for the referral of an order of constitutional
invalidity to the Constitutional Court.'),
('2d', 172, 'Any person or organ of state with a sufficient interest may appeal, or apply,
directly to the Constitutional Court to confirm or vary an order of constitutional
invalidity by a court in terms of this subsection.'),

('1', 174, 'Any appropriately qualified woman or man who is a fit and proper person may be
appointed as a judicial officer. Any person to be appointed to the Constitutional
Court must also be a South African citizen.'),
('2', 174, 'The need for the judiciary to reflect broadly the racial and gender composition of
South Africa must be considered when judicial officers are appointed.'),
('3', 174, 'The President as head of the national executive, after consulting the Judicial Service
Commission and the leaders of parties represented in the National Assembly,
appoints the Chief Justice and the Deputy Chief Justice and, after consulting the
Judicial Service Commission, appoints the President and Deputy President of the
Supreme Court of Appeal.'),
('4', 174, 'The other judges of the Constitutional Court are appointed by the President, as head
of the national executive, after consulting the Chief Justice and the leaders of parties
represented in the National Assembly, in accordance with the following procedure:'),
('4a', 174, 'The Judicial Service Commission must prepare a list of nominees with three
names more than the number of appointments to be made, and submit the list
to the President.'),
('4b', 174, 'The President may make appointments from the list, and must advise
the Judicial Service Commission, with reasons, if any of the nominees are
unacceptable and any appointment remains to be made.'),
('4c', 174, 'The Judicial Service Commission must supplement the list with further
nominees and the President must make the remaining appointments from the
supplemented list.'),
('5', 174, 'At all times, at least four members of the Constitutional Court must be persons who
were judges at the time they were appointed to the Constitutional Court.'),
('6', 174, 'The President must appoint the judges of all other courts on the advice of the
Judicial Service Commission.'),
('7', 174, 'Other judicial officers must be appointed in terms of an Act of Parliament
which must ensure that the appointment, promotion, transfer or dismissal of,
or disciplinary steps against, these judicial officers take place without favour or
prejudice.'),
('8', 174, 'Before judicial officers begin to perform their functions, they must take an oath
or affirm, in accordance with Schedule 2, that they will uphold and protect the
Constitution.'),

('1', 175, 'The President may appoint a woman or a man to serve as an acting Deputy Chief
Justice or judge of the Constitutional Court if there is a vacancy in any of those
offices , or if the person holding such an office is absent. The appointment must
be made on the recommendation of the Cabinet member responsible for the
administration of justice acting with the concurrence of the Chief Justice, and an
appointment as acting Deputy Chief Justice must be made from the ranks of the
judges who had been appointed to the Constitutional Court in terms of section
174(4).'),
('2', 175, 'The Cabinet member responsible for the administration of justice must appoint
acting judges to other courts after consulting the senior judge of the court on which
the acting judge will serve.'),

('1', 176, 'A Constitutional Court judge holds office for a non-renewable term of 12 years, or
until he or she attains the age of 70, whichever occurs first, except where an Act of
Parliament extends the term of office of a Constitutional Court judge.'),
('2', 176, 'Other judges hold office until they are discharged from active service in terms of an
Act of Parliament.'),
('3', 176, 'The salaries, allowances and benefits of judges may not be reduced.'),

('1', 177, 'A judge may be removed from office only if—'),
('1a', 177, 'the Judicial Service Commission finds that the judge suffers from an incapacity,
is grossly incompetent or is guilty of gross misconduct; and'),
('1b', 177, 'the National Assembly calls for that judge to be removed, by a resolution
adopted with a supporting vote of at least two thirds of its members.'),
('2', 177, 'The President must remove a judge from office upon adoption of a resolution calling
for that judge to be removed.'),
('3', 177, 'The President, on the advice of the Judicial Service Commission, may
suspend a judge who is the subject of a procedure in terms of subsection (1).'),

('1', 178, 'There is a Judicial Service Commission consisting of—'),
('1a', 178, 'the Chief Justice, who presides at meetings of the Commission;'),
('1b', 178, 'the President of the Supreme Court of Appeal;'),
('1c', 178, 'one Judge President designated by the Judges President;'),
('1d', 178, 'the Cabinet member responsible for the administration of justice, or an
alternate designated by that Cabinet member;'),
('1e', 178, 'two practising advocates nominated from within the advocates’ profession to
represent the profession as a whole, and appointed by the President;'),
('1f', 178, 'two practising attorneys nominated from within the attorneys’ profession to
represent the profession as a whole, and appointed by the President;'),
('1g', 178, 'one teacher of law designated by teachers of law at South African universities;'),
('1h', 178, 'six persons designated by the National Assembly from among its
members, at least three of whom must be members of opposition parties
represented in the Assembly;'),
('1i', 178, 'four permanent delegates to the National Council of Provinces designated
together by the Council with a supporting vote of at least six provinces;'),
('1j', 178, 'four persons designated by the President as head of the national executive,
after consulting the leaders of all the parties in the National Assembly; and'),
('1k', 178, 'when considering matters relating to a specific Division of the High Court
of South Africa, the Judge President of that Division and the Premier of the
province concerned, or an alternate designated by each of them.'),
('2', 178, 'If the number of persons nominated from within the advocates’ or attorneys’
profession in terms of subsection (1)(e) or (f) equals the number of vacancies to
be filled, the President must appoint them. If the number of persons nominated
exceeds the number of vacancies to be filled, the President, after consulting the
relevant profession, must appoint sufficient of the nominees to fill the vacancies,
taking into account the need to ensure that those appointed represent the
profession as a whole.'),
('3', 178, 'Members of the Commission designated by the National Council of Provinces serve
until they are replaced together, or until any vacancy occurs in their number. Other
members who were designated or nominated to the Commission serve until they
are replaced by those who designated or nominated them.'),
('4', 178, 'The Judicial Service Commission has the powers and functions assigned to it in the
Constitution and national legislation.'),
('5', 178, 'The Judicial Service Commission may advise the national government on any matter
relating to the judiciary or the administration of justice, but when it considers
any matter except the appointment of a judge, it must sit without the members
designated in terms of subsection (1)(h) and (i).'),
('6', 178, 'The Judicial Service Commission may determine its own procedure, but decisions of
the Commission must be supported by a majority of its members.'),
('7', 178, 'If the Chief Justice or the President of the Supreme Court of Appeal is temporarily
unable to serve on the Commission, the Deputy Chief Justice or the Deputy
President of the Supreme Court of Appeal, as the case may be, acts as his or her
alternate on the Commission.'),
('8', 178, 'The President and the persons who appoint, nominate or designate the members
of the Commission in terms of subsection (1)(c), (e), (f) and (g), may, in the same
manner appoint, nominate or designate an alternate for each of those members, to
serve on the Commission whenever the member concerned is temporarily unable to
do so by reason of his or her incapacity or absence from the Republic or for any other
sufficient reason.'),

('1', 179, 'There is a single national prosecuting authority in the Republic, structured in terms
of an Act of Parliament, and consisting of—'),
('1a', 179, 'a National Director of Public Prosecutions, who is the head of the prosecuting
authority, and is appointed by the President, as head of the national executive;
and'),
('1b', 179, 'Directors of Public Prosecutions and prosecutors as determined by an Act of
Parliament.'),
('2', 179, 'The prosecuting authority has the power to institute criminal proceedings on behalf
of the state, and to carry out any necessary functions incidental to instituting
criminal proceedings.'),
('3', 179, 'National legislation must ensure that the Directors of Public Prosecutions—'),
('3a', 179, 'are appropriately qualified; and'),
('3b', 179, 'are responsible for prosecutions in specific jurisdictions, subject to subsection
(5).'),
('4', 179, 'National legislation must ensure that the prosecuting authority exercises its
functions without fear, favour or prejudice.'),
('5', 179, 'The National Director of Public Prosecutions—'),
('5a', 179, 'must determine, with the concurrence of the Cabinet member responsible
for the administration of justice, and after consulting the Directors of Public
Prosecutions, prosecution policy, which must be observed in the prosecution
process;'),
('5b', 179, 'must issue policy directives which must be observed in the prosecution
process;'),
('5c', 179, 'may intervene in the prosecution process when policy directives are not
complied with; and'),
('5d', 179, 'may review a decision to prosecute or not to prosecute, after consulting the
relevant Director of Public Prosecutions and after taking representations within
a period specified by the National Director of Public Prosecutions, from the
following:'),
('6', 179, 'The Cabinet member responsible for the administration of justice must exercise final
responsibility over the prosecuting authority.'),
('7', 179, 'All other matters concerning the prosecuting authority must be determined by
national legislation.'),

('0', 180, 'National legislation may provide for any matter concerning the administration of justice
that is not dealt with in the Constitution, including—'),
('0a', 180, 'training programmes for judicial officers;'),
('0b', 180, 'procedures for dealing with complaints about judicial officers; and'),
('0c', 180, 'the participation of people other than judicial officers in court decisions.');
GO

INSERT INTO [MainSchema].Clauses(ClauseID, SectionID, SubsectionID, ClauseText)
VALUES
('i', 167, '3b', 'constitutional matters; and'),
('ii', 167, '3b', 'any other matter, if the Constitutional Court grants leave to appeal on
the grounds that the matter raises an arguable point of law of general
public importance which ought to be considered by that Court, and'),

('i', 168, '3b', 'appeals;'),
('ii', 168, '3b', 'issues connected with appeals; and'),
('iii', 168, '3b', 'any other matter that may be referred to it in circumstances defined by
an Act of Parliament.'),

('i', 169, '1a', 'the Constitutional Court has agreed to hear directly in terms of section
167(6)(a); or'),
('ii', 169, '1a', 'is assigned by an Act of Parliament to another court of a status similar to
the High Court of South Africa; and'),

('i', 172, '1b', 'an order limiting the retrospective effect of the declaration of invalidity;
and'),
('ii', 172, '1b', 'an order suspending the declaration of invalidity for any period and on
any conditions, to allow the competent authority to correct the defect.'),

('i', 179, '5d', 'The accused person.'),
('ii', 179, '5d', 'The complainant.'),
('iii', 179, '5d', 'Any other person or party whom the National Director considers to be
relevant.');
GO

--/* /////////////// Chapter 9's contents /////////// */
INSERT INTO [MainSchema].Sections (SectionID, ChapterID, SectionTitle, SectionText)
VALUES
(181, 9, 'Establishment and governing principles', NULL),
(182, 9, 'Functions of Public Protector', NULL),
(183, 9, 'Tenure', 'The Public Protector is appointed for a non-renewable period of seven years.'),
(184, 9, 'Functions of South African Human Rights Commission', NULL),
(185, 9, 'Functions of Commission', NULL),
(186, 9, 'Composition of Commission', NULL),
(187, 9, 'Functions of Commission for Gender Equality', NULL),
(188, 9, 'Functions of Auditor-General', NULL),
(189, 9, 'Tenure', 'The Auditor-General must be appointed for a fixed, non-renewable term of between five and ten years.'),
(190, 9, 'Functions of Electoral Commission', NULL),
(191, 9, 'Composition of Electoral Commission', 'The Electoral Commission must be composed of at least three persons. The number of members and their terms of office must be prescribed by national legislation.'),
(192, 9, 'Functions of Electoral Commission', 'National legislation must establish an independent authority to regulate broadcasting in
the public interest, and to ensure fairness and a diversity of views broadly representing
South African society.'),
(193, 9, 'Appointments', NULL),
(194, 9, 'Removal from office', NULL);

INSERT INTO [MainSchema].Subsections(SubsectionID, SectionID, SubsectionText)
VALUES
('1', 181, 'The following state institutions strengthen constitutional democracy in the
Republic:'),
('1a', 181, 'The Public Protector.'),
('1b', 181, 'The South African Human Rights Commission.'),
('1c', 181, 'The Commission for the Promotion and Protection of the Rights of Cultural,
Religious and Linguistic Communities.'),
('1d', 181, 'The Commission for Gender Equality.'),
('1e', 181, 'The Auditor-General.'),
('1f', 181, 'The Electoral Commission.'),
('2', 181, 'These institutions are independent, and subject only to the Constitution and the
law, and they must be impartial and must exercise their powers and perform their
functions without fear, favour or prejudice.'),
('3', 181, 'Other organs of state, through legislative and other measures, must assist and
protect these institutions to ensure the independence, impartiality, dignity and
effectiveness of these institutions.'),
('4', 181, 'No person or organ of state may interfere with the functioning of these institutions.'),
('5', 181, 'These institutions are accountable to the National Assembly, and must report on
their activities and the performance of their functions to the Assembly at least once
a year.'),

('1', 182, 'The Public Protector has the power, as regulated by national legislation—'),
('1a', 182, 'to investigate any conduct in state affairs, or in the public administration in any
sphere of government, that is alleged or suspected to be improper or to result
in any impropriety or prejudice;'),
('1b', 182, 'to report on that conduct; and'),
('1c', 182, 'to take appropriate remedial action.'),
('2', 182, 'The Public Protector has the additional powers and functions prescribed by national
legislation.'),
('3', 182, 'The Public Protector may not investigate court decisions.'),
('4', 182, 'The Public Protector must be accessible to all persons and communities.'),
('5', 182, 'Any report issued by the Public Protector must be open to the public unless
exceptional circumstances, to be determined in terms of national legislation, require
that a report be kept confidential.'),

('1', 184, 'The South African Human Rights Commission must—'),
('1a', 184, 'promote respect for human rights and a culture of human rights;'),
('1b', 184, 'promote the protection, development and attainment of human rights; and'),
('1c', 184, 'monitor and assess the observance of human rights in the Republic.'),
('2', 184, 'The South African Human Rights Commission has the powers, as regulated by
national legislation, necessary to perform its functions, including the power—'),
('2a', 184, 'to investigate and to report on the observance of human rights;'),
('2b', 184, 'to take steps to secure appropriate redress where human rights have been
violated;'),
('2c', 184, 'to carry out research; and'),
('2d', 184, 'to educate.'),
('3', 184, 'Each year, the South African Human Rights Commission must require relevant
organs of state to provide the Commission with information on the measures that
they have taken towards the realisation of the rights in the Bill of Rights concerning
housing, health care, food, water, social security, education and the environment.'),
('4', 184, 'The South African Human Rights Commission has the additional powers and
functions prescribed by national legislation.'),

('1', 185, 'The primary objects of the Commission for the Promotion and Protection of the
Rights of Cultural, Religious and Linguistic Communities are—'),
('1a', 185, 'to promote respect for the rights of cultural, religious and linguistic
communities;'),
('1b', 185, 'to promote and develop peace, friendship, humanity, tolerance and national
unity among cultural, religious and linguistic communities, on the basis of
equality, non-discrimination and free association; and'),
('1c', 185, 'to recommend the establishment or recognition, in accordance with national
legislation, of a cultural or other council or councils for a community or
communities in South Africa.'),
('2', 185, 'The Commission has the power, as regulated by national legislation, necessary to
achieve its primary objects, including the power to monitor, investigate, research,
educate, lobby, advise and report on issues concerning the rights of cultural,
religious and linguistic communities.'),
('3', 185, 'The Commission may report any matter which falls within its powers and functions
to the South African Human Rights Commission for investigation.'),
('4', 185, 'The Commission has the additional powers and functions prescribed by national
legislation.'),

('1', 186, 'The number of members of the Commission for the Promotion and Protection of the
Rights of Cultural, Religious and Linguistic Communities and their appointment and
terms of office must be prescribed by national legislation.'),
('2', 186, 'The composition of the Commission must—'),
('2a', 186, 'be broadly representative of the main cultural, religious and linguistic
communities in South Africa; and'),
('2b', 186, 'broadly reflect the gender composition of South Africa.'),

('1', 187, 'The Commission for Gender Equality must promote respect for gender equality and
the protection, development and attainment of gender equality.'),
('2', 187, 'The Commission for Gender Equality has the power, as regulated by national
legislation, necessary to perform its functions, including the power to monitor,
investigate, research, educate, lobby, advise and report on issues concerning gender
equality.'),
('3', 187, 'The Commission for Gender Equality has the additional powers and functions
prescribed by national legislation.'),

('1', 188, 'The Auditor-General must audit and report on the accounts, financial
statements and financial management of—'),
('1a', 188, 'all national and provincial state departments and administrations;'),
('1b', 188, 'all municipalities; and'),
('1c', 188, 'any other institution or accounting entity required by national or provincial
legislation to be audited by the Auditor-General.'),
('2', 188, 'In addition to the duties prescribed in subsection (1), and subject to any legislation,
the Auditor-General may audit and report on the accounts, financial statements and
financial management of—'),
('2a', 188, 'any institution funded from the National Revenue Fund or a Provincial Revenue
Fund or by a municipality; or'),
('2b', 188, 'any institution that is authorised in terms of any law to receive money for a
public purpose.'),
('3', 188, 'The Auditor-General must submit audit reports to any legislature that has a direct
interest in the audit, and to any other authority prescribed by national legislation.
All reports must be made public.'),
('4', 188, 'The Auditor-General has the additional powers and functions prescribed by national
legislation.'),

('1', 190, 'The Electoral Commission must—'),
('1a', 190, 'manage elections of national, provincial and municipal legislative bodies in
accordance with national legislation;'),
('1b', 190, 'ensure that those elections are free and fair; and'),
('1c', 190, 'declare the results of those elections within a period that must be prescribed
by national legislation and that is as short as reasonably possible.'),
('2', 190, 'The Electoral Commission has the additional powers and functions prescribed by
national legislation.'),

('1', 193, 'The Public Protector and the members of any Commission established by this
Chapter must be women or men who—'),
('1a', 193, 'are South African citizens;'),
('1b', 193, 'are fit and proper persons to hold the particular office; and'),
('1c', 193, 'comply with any other requirements prescribed by national legislation.'),
('2', 193, 'The need for a Commission established by this Chapter to reflect broadly the race
and gender composition of South Africa must be considered when members are
appointed.'),
('3', 193, 'The Auditor-General must be a woman or a man who is a South African citizen and
a fit and proper person to hold that office. Specialised knowledge of, or experience
in, auditing, state finances and public administration must be given due regard in
appointing the Auditor-General.'),
('4', 193, 'The President, on the recommendation of the National Assembly, must appoint the
Public Protector, the Auditor-General and the members of—'),
('4a', 193, 'the South African Human Rights Commission;'),
('4b', 193, 'the Commission for Gender Equality; and'),
('4c', 193, 'the Electoral Commission.'),
('5', 193, 'The National Assembly must recommend persons—'),
('5a', 193, 'nominated by a committee of the Assembly proportionally composed of
members of all parties represented in the Assembly; and'),
('5b', 193, 'approved by the Assembly by a resolution adopted with a supporting vote—'),
('6', 193, 'The involvement of civil society in the recommendation process may be provided for
as envisaged in section 59(1)(a).'),

('1', 194, 'The Public Protector, the Auditor-General or a member of a Commission established
by this Chapter may be removed from office only on—'),
('1a', 194, 'the ground of misconduct, incapacity or incompetence;'),
('1b', 194, 'a finding to that effect by a committee of the National Assembly; and'),
('1c', 194, 'the adoption by the Assembly of a resolution calling for that person’s removal
from office.'),
('2', 194, 'A resolution of the National Assembly concerning the removal from office of—'),
('2a', 194, 'the Public Protector or the Auditor-General must be adopted with a supporting
vote of at least two thirds of the members of the Assembly; or'),
('2b', 194, 'a member of a Commission must be adopted with a supporting vote of a
majority of the members of the Assembly.'),
('3', 194, 'The President—'),
('3a', 194, 'may suspend a person from office at any time after the start of the proceedings
of a committee of the National Assembly for the removal of that person; and'),
('3b', 194, 'must remove a person from office upon adoption by the Assembly of the
resolution calling for that person’s removal.');
GO

INSERT INTO [MainSchema].Clauses(ClauseID, SectionID, SubsectionID, ClauseText)
VALUES
('i', 193, '5b', 'of at least 60 per cent of the members of the Assembly, if the
recommendation concerns the appointment of the Public Protector or
the Auditor-General; or'),
('ii', 193, '5b', 'of a majority of the members of the Assembly, if the recommendation
concerns the appointment of a member of a Commission.');
GO

/* /////////////// Chapter 10's contents /////////// */
INSERT INTO [MainSchema].Sections (SectionID, ChapterID, SectionTitle, SectionText)
VALUES
(195, 10, 'Basic values and principles governing public administration', NULL),
(196, 10, 'Public Service Commission', NULL),
(197, 10, 'Public Service', NULL);
GO

INSERT INTO [MainSchema].Subsections(SubsectionID, SectionID, SubsectionText)
VALUES
('1', 195, 'Public administration must be governed by the democratic values and principles
enshrined in the Constitution, including the following principles:'),
('1a', 195, 'A high standard of professional ethics must be promoted and maintained.'),
('1b', 195, 'Efficient, economic and effective use of resources must be promoted.'),
('1c', 195, 'Public administration must be development-oriented.'),
('1d', 195, 'Services must be provided impartially, fairly, equitably and without bias.'),
('1e', 195, 'People’s needs must be responded to, and the public must be encouraged to
participate in policy-making.'),
('1f', 195, 'Public administration must be accountable.'),
('1g', 195, 'Transparency must be fostered by providing the public with timely, accessible
and accurate information.'),
('1h', 195, 'Good human-resource management and career-development practices, to
maximise human potential, must be cultivated.'),
('1i', 195, 'Public administration must be broadly representative of the South African
people, with employment and personnel management practices based on
ability, objectivity, fairness, and the need to redress the imbalances of the past
to achieve broad representation.'),
('2', 195, 'The above principles apply to—'),
('2a', 195, 'administration in every sphere of government;'),
('2b', 195, 'organs of state; and'),
('2c', 195, 'public enterprises.'),
('3', 195, 'National legislation must ensure the promotion of the values and principles listed in
subsection (1).'),
('4', 195, 'The appointment in public administration of a number of persons on policy
considerations is not precluded, but national legislation must regulate these
appointments in the public service.'),
('5', 195, 'Legislation regulating public administration may differentiate between different
sectors, administrations or institutions.'),
('6', 195, 'The nature and functions of different sectors, administrations or institutions of
public administration are relevant factors to be taken into account in legislation
regulating public administration.'),

('1', 196, 'There is a single Public Service Commission for the Republic.'),
('2', 196, 'The Commission is independent and must be impartial, and must exercise its
powers and perform its functions without fear, favour or prejudice in the interest of
the maintenance of effective and efficient public administration and a high standard
of professional ethics in the public service. The Commission must be regulated by
national legislation.'),
('3', 196, 'Other organs of state, through legislative and other measures, must assist and
protect the Commission to ensure the independence, impartiality, dignity and
effectiveness of the Commission. No person or organ of state may interfere with the
functioning of the Commission.'),
('4', 196, 'The powers and functions of the Commission are—'),
('4a', 196, 'to promote the values and principles set out in section 195, throughout the
public service;'),
('4b', 196, 'to investigate, monitor and evaluate the organisation and administration, and
the personnel practices, of the public service;'),
('4c', 196, 'to propose measures to ensure effective and efficient performance within the
public service;'),
('4d', 196, 'to give directions aimed at ensuring that personnel procedures relating to
recruitment, transfers, promotions and dismissals comply with the values and
principles set out in section 195;'),
('4e', 196, 'to report in respect of its activities and the performance of its functions,
including any finding it may make and directions and advice it may give, and
to provide an evaluation of the extent to which the values and principles set
out in section 195 are complied with; and'),
('4f', 196, 'either of its own accord or on receipt of any complaint—'),
('4g', 196, 'to exercise or perform the additional powers or functions prescribed by an Act
of Parliament.'),
('5', 196, 'The Commission is accountable to the National Assembly.'),
('6', 196, 'The Commission must report at least once a year in terms of subsection (4)(e)—'),
('6a', 196, 'to the National Assembly; and'),
('6b', 196, 'in respect of its activities in a province, to the legislature of that province.'),
('7', 196, 'The Commission has the following 14 commissioners appointed by the President:'),
('7a', 196, 'Five commissioners approved by the National Assembly in accordance with
subsection (8)(a); and'),
('7b', 196, 'one commissioner for each province nominated by the Premier of the province
in accordance with subsection (8)(b).'),
('8a', 196, 'A commissioner appointed in terms of subsection (7)(a) must be—'),
('8b', 196, 'A commissioner nominated by the Premier of a province must be—'),
('9', 196, 'An Act of Parliament must regulate the procedure for the appointment of
commissioners.'),
('10', 196, 'A commissioner is appointed for a term of five years, which is renewable for one
additional term only, and must be a woman or a man who is—'),
('10a', 196, 'a South African citizen; and'),
('10b', 196, 'a fit and proper person with knowledge of, or experience in, administration,
management or the provision of public services.'),
('11', 196, 'A commissioner may be removed from office only on—'),
('11a', 196, 'a finding to that effect by a committee of the National Assembly or, in the case
of a commissioner nominated by the Premier of a province, by a committee of
the legislature of that province; and'),
('11b', 196, 'the adoption by the Assembly or the provincial legislature concerned, of a
resolution with a supporting vote of a majority of its members calling for the
commissioner’s removal from office.'),
('12', 196, 'The President must remove the relevant commissioner from office upon—'),
('12a', 196, 'the adoption by the Assembly of a resolution calling for that commissioner’s
removal; or'),
('12b', 196, 'written notification by the Premier that the provincial legislature has adopted
a resolution calling for that commissioner’s removal.'),
('13', 196, 'Commissioners referred to in subsection (7)(b) may exercise the powers and
perform the functions of the Commission in their provinces as prescribed by national
legislation.'),

('1', 197, 'Within public administration there is a public service for the Republic, which must
function, and be structured, in terms of national legislation, and which must loyally
execute the lawful policies of the government of the day.'),
('2', 197, 'The terms and conditions of employment in the public service must be regulated
by national legislation. Employees are entitled to a fair pension as regulated by
national legislation.'),
('3', 197, 'No employee of the public service may be favoured or prejudiced only because that
person supports a particular political party or cause.'),
('4', 197, 'Provincial governments are responsible for the recruitment, appointment,
promotion, transfer and dismissal of members of the public service in their
administrations within a framework of uniform norms and standards applying to
the public service.');
GO

INSERT INTO [MainSchema].Clauses(ClauseID, SectionID, SubsectionID, ClauseText)
VALUES
('i', 196, '4f', 'to investigate and evaluate the application of personnel and public
administration practices, and to report to the relevant executive
authority and legislature;'),
('ii', 196, '4f', 'to investigate grievances of employees in the public service concerning
official acts or omissions, and recommend appropriate remedies;'),
('iii', 196, '4f', 'to monitor and investigate adherence to applicable procedures in the
public service; and'),
('iv', 196, '4f', 'to advise national and provincial organs of state regarding personnel
practices in the public service, including those relating to the
recruitment, appointment, transfer, discharge and other aspects of the
careers of employees in the public service; and');
GO

/* /////////////// Chapter 11's contents /////////// */
INSERT INTO [MainSchema].Sections (SectionID, ChapterID, SectionTitle, SectionText)
VALUES
(198, 11, 'Governing principles', NULL),
(199, 11, 'Establishment, structuring, and conduct of security services', NULL),
(200, 11, 'Defence force', NULL),
(201, 11, 'Political responsibility', NULL),
(202, 11, 'Command of defence force', NULL),
(203, 11, 'State of national defence', NULL),
(204, 11, 'Defence civilian secretariat', 'A civilian secretariat for defence must be established by national legislation to function
under the direction of the Cabinet member responsible for defence.'),
(205, 11, 'Police service', NULL),
(206, 11, 'Political responsibility', NULL),
(207, 11, 'Control of police service', NULL),
(208, 11, 'Police civilian secretariat', 'A civilian secretariat for the police service must be established by national legislation to
function under the direction of the Cabinet member responsible for policing.'),
(209, 11, 'Establishment and control of intelligence services', NULL),
(210, 11, 'Powers, functions and monitoring', NULL);

INSERT INTO [MainSchema].Subsections(SubsectionID, SectionID, SubsectionText)
VALUES
('0', 198, 'The following principles govern national security in the Republic:'),
('0a', 198, 'National security must reflect the resolve of South Africans, as individuals and
as a nation, to live as equals, to live in peace and harmony, to be free from fear
and want and to seek a better life.'),
('0b', 198, 'The resolve to live in peace and harmony precludes any South African citizen
from participating in armed conflict, nationally or internationally, except as
provided for in terms of the Constitution or national legislation.'),
('0c', 198, 'National security must be pursued in compliance with the law, including
international law.'),
('0d', 198, 'National security is subject to the authority of Parliament and the national
executive.'),

('1', 199, 'The security services of the Republic consist of a single defence force, a single police
service and any intelligence services established in terms of the Constitution.'),
('2', 199, 'The defence force is the only lawful military force in the Republic.'),
('3', 199, 'Other than the security services established in terms of the Constitution, armed
organisations or services may be established only in terms of national legislation.'),
('4', 199, 'The security services must be structured and regulated by national legislation.'),
('5', 199, 'The security services must act, and must teach and require their members to act, in
accordance with the Constitution and the law, including customary international
law and international agreements binding on the Republic.'),
('6', 199, 'No member of any security service may obey a manifestly illegal order.'),
('7', 199, 'Neither the security services, nor any of their members, may, in the performance of
their functions—'),
('7a', 199, 'prejudice a political party interest that is legitimate in terms of the
Constitution; or'),
('7b', 199, 'further, in a partisan manner, any interest of a political party.'),
('8', 199, 'To give effect to the principles of transparency and accountability, multi-party
parliamentary committees must have oversight of all security services in a manner
determined by national legislation or the rules and orders of Parliament.'),

('1', 200, 'The defence force must be structured and managed as a disciplined military force.'),
('2', 200, 'The primary object of the defence force is to defend and protect the Republic, its
territorial integrity and its people in accordance with the Constitution and the
principles of international law regulating the use of force.'),

('1', 201, 'A member of the Cabinet must be responsible for defence.'),
('2', 201, 'Only the President, as head of the national executive, may authorise the
employment of the defence force—'),
('2a', 201, 'in co-operation with the police service;'),
('2b', 201, 'in defence of the Republic; or'),
('2c', 201, 'in fulfilment of an international obligation.'),
('3', 201, 'When the defence force is employed for any purpose mentioned in subsection (2),
the President must inform Parliament, promptly and in appropriate detail, of—'),
('3a', 201, 'the reasons for the employment of the defence force;'),
('3b', 201, 'any place where the force is being employed;'),
('3c', 201, 'the number of people involved; and'),
('3d', 201, 'the period for which the force is expected to be employed.'),
('4', 201, 'If Parliament does not sit during the first seven days after the defence force
is employed as envisaged in subsection (2), the President must provide the
information required in subsection (3) to the appropriate oversight committee.'),

('1', 202, 'The President as head of the national executive is Commander-in-Chief of the
defence force, and must appoint the Military Command of the defence force.'),
('2', 202, 'Command of the defence force must be exercised in accordance with the directions
of the Cabinet member responsible for defence, under the authority of the
President.'),

('1', 203, 'The President as head of the national executive may declare a state of
national defence, and must inform Parliament promptly and in appropriate detail
of—'),
('1a', 203, 'the reasons for the declaration;'),
('1b', 203, 'any place where the defence force is being employed; and'),
('1c', 203, 'the number of people involved.'),
('2', 203, 'If Parliament is not sitting when a state of national defence is declared, the
President must summon Parliament to an extraordinary sitting within seven days of
the declaration.'),
('3', 203, 'A declaration of a state of national defence lapses unless it is approved by
Parliament within seven days of the declaration.'),

('1', 205, 'The national police service must be structured to function in the national, provincial
and, where appropriate, local spheres of government.'),
('2', 205, 'National legislation must establish the powers and functions of the police service
and must enable the police service to discharge its responsibilities effectively, taking
into account the requirements of the provinces.'),
('3', 205, 'The objects of the police service are to prevent, combat and investigate crime, to
maintain public order, to protect and secure the inhabitants of the Republic and
their property, and to uphold and enforce the law.'),

('1', 206, 'A member of the Cabinet must be responsible for policing and must determine
national policing policy after consulting the provincial governments and taking
into account the policing needs and priorities of the provinces as determined by the
provincial executives.'),
('2', 206, 'The national policing policy may make provision for different policies in respect of
different provinces after taking into account the policing needs and priorities of
these provinces.'),
('3', 206, 'Each province is entitled—'),
('3a', 206, 'to monitor police conduct;'),
('3b', 206, 'to oversee the effectiveness and efficiency of the police service, including
receiving reports on the police service;'),
('3c', 206, 'to promote good relations between the police and the community;'),
('3d', 206, 'to assess the effectiveness of visible policing; and'),
('3e', 206, 'to liaise with the Cabinet member responsible for policing with respect to
crime and policing in the province.'),
('4', 206, 'A provincial executive is responsible for policing functions—'),
('4a', 206, 'vested in it by this Chapter;'),
('4b', 206, 'assigned to it in terms of national legislation; and'),
('4c', 206, 'allocated to it in the national policing policy.'),
('5', 206, 'In order to perform the functions set out in subsection (3), a province—'),
('5a', 206, 'may investigate, or appoint a commission of inquiry into, any complaints of
police inefficiency or a breakdown in relations between the police and any
community; and'),
('5b', 206, 'must make recommendations to the Cabinet member responsible for policing.'),
('6', 206, 'On receipt of a complaint lodged by a provincial executive, an independent police
complaints body established by national legislation must investigate any alleged
misconduct of, or offence committed by, a member of the police service in the
province.'),
('7', 206, 'National legislation must provide a framework for the establishment, powers,
functions and control of municipal police services.'),
('8', 206, 'A committee composed of the Cabinet member and the members of the Executive
Councils responsible for policing must be established to ensure effective coordination
of the police service and effective co-operation among the spheres of
government.'),
('9', 206, 'A provincial legislature may require the provincial commissioner of the province to
appear before it or any of its committees to answer questions.'),

('1', 207, 'The President as head of the national executive must appoint a woman or a man as
the National Commissioner of the police service, to control and manage the police
service.'),
('2', 207, 'The National Commissioner must exercise control over and manage the police
service in accordance with the national policing policy and the directions of the
Cabinet member responsible for policing.'),
('3', 207, 'The National Commissioner, with the concurrence of the provincial executive, must
appoint a woman or a man as the provincial commissioner for that province, but if
the National Commissioner and the provincial executive are unable to agree on the
appointment, the Cabinet member responsible for policing must mediate between
the parties.'),
('4', 207, 'The provincial commissioners are responsible for policing in their respective
provinces—'),
('4a', 207, 'as prescribed by national legislation; and'),
('4b', 207, 'subject to the power of the National Commissioner to exercise control over and
manage the police service in terms of subsection (2).'),
('5', 207, 'The provincial commissioner must report to the provincial legislature annually
on policing in the province, and must send a copy of the report to the National
Commissioner.'),
('6', 207, 'If the provincial commissioner has lost the confidence of the provincial executive,
that executive may institute appropriate proceedings for the removal or transfer
of, or disciplinary action against, that commissioner, in accordance with national
legislation.'),

('1', 209, 'Any intelligence service, other than any intelligence division of the defence force
or police service, may be established only by the President, as head of the national
executive, and only in terms of national legislation.'),
('2', 209, 'The President as head of the national executive must appoint a woman or a man as
head of each intelligence service established in terms of subsection (1), and must
either assume political responsibility for the control and direction of any of those
services, or designate a member of the Cabinet to assume that responsibility.'),

('0', 210, 'National legislation must regulate the objects, powers and functions of the intelligence
services, including any intelligence division of the defence force or police service, and must
provide for—'),
('0a', 210, 'the co-ordination of all intelligence services; and'),
('0b', 210, 'civilian monitoring of the activities of those services by an inspector appointed
by the President, as head of the national executive, and approved by a
resolution adopted by the National Assembly with a supporting vote of at least
two thirds of its members.');
GO

/* /////////////// Chapter 12's contents /////////// */
INSERT INTO [MainSchema].Sections (SectionID, ChapterID, SectionTitle, SectionText)
VALUES
(211, 12, 'Recognition', NULL),
(212, 12, 'Role of traditional leaders', NULL);

INSERT INTO [MainSchema].Subsections (SubsectionID, SectionID, SubsectionText)
VALUES
('1', 211, 'The institution, status and role of traditional leadership, according to customary law,
are recognised, subject to the Constitution.'),
('2', 211, 'A traditional authority that observes a system of customary law may function
subject to any applicable legislation and customs, which includes amendments to,
or repeal of, that legislation or those customs.'),
('3', 211, 'The courts must apply customary law when that law is applicable, subject to the
Constitution and any legislation that specifically deals with customary law.'),
('1', 212, 'National legislation may provide for a role for traditional leadership as an institution
at local level on matters affecting local communities.'),
('2', 212, 'To deal with matters relating to traditional leadership, the role of traditional leaders,
customary law and the customs of communities observing a system of customary
law—'),
('2a', 212, 'national or provincial legislation may provide for the establishment of houses
of traditional leaders; and'),
('2b', 212, 'national legislation may establish a council of traditional leaders.');
GO


/* /////////////// Chapter 13's contents /////////// */
INSERT INTO [MainSchema].Sections (SectionID, ChapterID, SectionTitle, SectionText)
VALUES
(213, 13, 'National Revenue Fund', NULL),
(214, 13, 'Equitable shares and allocations of revenue', NULL),
(215, 13, 'National, provincial and municipal budgets', NULL),
(216, 13, 'Treasury control', NULL),
(217, 13, 'Procurement', NULL),
(218, 13, 'Government guarantees', NULL),
(219, 13, 'Remuneration of persons holding public office', NULL),
(220, 13, 'Establishment and functions', NULL),
(221, 13, 'Appointment and tenure of members', NULL),
(222, 13, 'Reports', 'The Commission must report regularly both to Parliament and to the provincial
legislatures.'),
(223, 13, 'Establishment', 'The South African Reserve Bank is the central bank of the Republic and is regulated in
terms of an Act of Parliament.'),
(224, 13, 'Primary object', NULL),
(225, 13, 'Powers and functions', 'The powers and functions of the South African Reserve Bank are those customarily
exercised and performed by central banks, which powers and functions must be
determined by an Act of Parliament and must be exercised or performed subject to the
conditions prescribed in terms of that Act.'),
(226, 13, 'Provincial Revenue Funds', NULL),
(227, 13, 'National sources of provincial and local government funding', NULL),
(228, 13, 'Provincial taxes', NULL),
(229, 13, 'Municipal fiscal powers and functions', NULL),
(230, 13, 'Provincial loans', NULL),
(23065, 13, 'Municipal loans', NULL);

INSERT INTO [MainSchema].Subsections(SubsectionID, SectionID, SubsectionText)
VALUES
('1', 213, 'There is a National Revenue Fund into which all money received by the national
government must be paid, except money reasonably excluded by an Act of
Parliament.'),
('2', 213, 'Money may be withdrawn from the National Revenue Fund only—'),
('2a', 213, 'in terms of an appropriation by an Act of Parliament; or'),
('2b', 213, 'as a direct charge against the National Revenue Fund, when it is provided for in
the Constitution or an Act of Parliament.'),
('3', 213, 'A province’s equitable share of revenue raised nationally is a direct charge against
the National Revenue Fund.'),

('1', 214, 'An Act of Parliament must provide for—'),
('1a', 214, 'the equitable division of revenue raised nationally among the national,
provincial and local spheres of government;'),
('1b', 214, 'the determination of each province’s equitable share of the provincial share of
that revenue; and'),
('1c', 214, 'any other allocations to provinces, local government or municipalities from
the national government’s share of that revenue, and any conditions on which
those allocations may be made.'),
('2', 214, 'The Act referred to in subsection (1) may be enacted only after the provincial
governments, organised local government and the Financial and Fiscal Commission
have been consulted, and any recommendations of the Commission have been
considered, and must take into account—'),
('2a', 214, 'the national interest;'),
('2b', 214, 'any provision that must be made in respect of the national debt and other
national obligations;'),
('2c', 214, 'the needs and interests of the national government, determined by objective
criteria;'),
('2d', 214, 'the need to ensure that the provinces and municipalities are able to provide
basic services and perform the functions allocated to them;'),
('2e', 214, 'the fiscal capacity and efficiency of the provinces and municipalities;'),
('2f', 214, 'developmental and other needs of provinces, local government and
municipalities;'),
('2g', 214, 'economic disparities within and among the provinces;'),
('2h', 214, 'obligations of the provinces and municipalities in terms of national legislation;'),
('2i', 214, 'the desirability of stable and predictable allocations of revenue shares; and'),
('2j', 214, 'the need for flexibility in responding to emergencies or other temporary needs,
and other factors based on similar objective criteria.'),

('1', 215, 'National, provincial and municipal budgets and budgetary processes must promote
transparency, accountability and the effective financial management of the
economy, debt and the public sector.'),
('2', 215, 'National legislation must prescribe—'),
('2a', 215, 'the form of national, provincial and municipal budgets;'),
('2b', 215, 'when national and provincial budgets must be tabled; and'),
('2c', 215, 'that budgets in each sphere of government must show the sources of revenue
and the way in which proposed expenditure will comply with national
legislation.'),
('3', 215, 'Budgets in each sphere of government must contain—'),
('3a', 215, 'estimates of revenue and expenditure, differentiating between capital and
current expenditure;'),
('3b', 215, 'proposals for financing any anticipated deficit for the period to which they
apply; and'),
('3c', 215, 'an indication of intentions regarding borrowing and other forms of public
liability that will increase public debt during the ensuing year.'),

('1', 216, 'National legislation must establish a national treasury and prescribe measures to
ensure both transparency and expenditure control in each sphere of government, by
introducing—'),
('1a', 216, 'generally recognised accounting practice;'),
('1b', 216, 'uniform expenditure classifications; and'),
('1c', 216, 'uniform treasury norms and standards.'),
('2', 216, 'The national treasury must enforce compliance with the measures established in
terms of subsection (1), and may stop the transfer of funds to an organ of state
if that organ of state commits a serious or persistent material breach of those
measures.'),
('3', 216, 'A decision to stop the transfer of funds due to a province in terms of section 214(1)
(b) may be taken only in the circumstances mentioned in subsection (2) and—'),
('3a', 216, 'may not stop the transfer of funds for more than 120 days; and'),
('3b', 216, 'may be enforced immediately, but will lapse retrospectively unless Parliament
approves it following a process substantially the same as that established
in terms of section 76(1) and prescribed by the joint rules and orders of
Parliament. This process must be completed within 30 days of the decision by
the national treasury.'),
('4', 216, 'Parliament may renew a decision to stop the transfer of funds for no more than 120
days at a time, following the process established in terms of subsection (3).'),
('5', 216, 'Before Parliament may approve or renew a decision to stop the transfer of funds to a
province—'),
('5a', 216, 'the Auditor-General must report to Parliament; and'),
('5b', 216, 'the province must be given an opportunity to answer the allegations against
it, and to state its case, before a committee.'),

('1', 217, 'When an organ of state in the national, provincial or local sphere of government,
or any other institution identified in national legislation, contracts for goods
or services, it must do so in accordance with a system which is fair, equitable,
transparent, competitive and cost-effective.'),
('2', 217, 'Subsection (1) does not prevent the organs of state or institutions referred to in that
subsection from implementing a procurement policy providing for—'),
('2a', 217, 'categories of preference in the allocation of contracts; and'),
('2b', 217, 'the protection or advancement of persons, or categories of persons,
disadvantaged by unfair discrimination.'),
('3', 217, 'National legislation must prescribe a framework within which the policy referred to
in subsection (2) must be implemented.'),

('1', 218, 'The national government, a provincial government or a municipality may guarantee
a loan only if the guarantee complies with any conditions set out in national
legislation.'),
('2', 218, 'National legislation referred to in subsection (1) may be enacted only after any
recommendations of the Financial and Fiscal Commission have been considered.'),
('3', 218, 'Each year, every government must publish a report on the guarantees it has
granted.'),

('1', 219, 'An Act of Parliament must establish a framework for determining—'),
('1a', 219, 'the salaries, allowances and benefits of members of the National
Assembly, permanent delegates to the National Council of Provinces, members
of the Cabinet, Deputy Ministers, traditional leaders and members of any
councils of traditional leaders; and'),
('1b', 219, 'the upper limit of salaries, allowances or benefits of members of provincial
legislatures, members of Executive Councils and members of Municipal
Councils of the different categories.'),
('2', 219, 'National legislation must establish an independent commission to make
recommendations concerning the salaries, allowances and benefits referred to in
subsection (1).'),
('3', 219, 'Parliament may pass the legislation referred to in subsection (1) only after
considering any recommendations of the commission established in terms of
subsection (2).'),
('4', 219, 'The national executive, a provincial executive, a municipality or any other relevant
authority may implement the national legislation referred to in subsection (1) only
after considering any recommendations of the commission established in terms of
subsection (2).'),
('5', 219, 'National legislation must establish frameworks for determining the salaries,
allowances and benefits of judges, the Public Protector, the Auditor-General,
and members of any commission provided for in the Constitution, including the
broadcasting authority referred to in section 192.'),

('1', 220, 'There is a Financial and Fiscal Commission for the Republic which makes
recommendations envisaged in this Chapter, or in national legislation, to
Parliament, provincial legislatures and any other authorities determined by national
legislation.'),
('2', 220, 'The Commission is independent and subject only to the Constitution and the law,
and must be impartial.'),
('3', 220, 'The Commission must function in terms of an Act of Parliament and, in
performing its functions, must consider all relevant factors, including those listed in
section 214(2).'),

('1', 221, 'The Commission consists of the following women and men appointed by the
President, as head of the national executive:'),
('1a', 221, 'A chairperson and a deputy chairperson;'),
('1b', 221, 'three persons selected, after consulting the Premiers, from a list compiled in
accordance with a process prescribed by national legislation;'),
('1c', 221, 'two persons selected, after consulting organised local government, from a list
compiled in accordance with a process prescribed by national legislation; and'),
('1d', 221, 'two other persons.'),
('1A_i', 221, 'National legislation referred to in subsection (1) must provide for the participation
of—'),
('1A_ia', 221, 'the Premiers in the compilation of a list envisaged in subsection (1) (b); and'),
('1A_ib', 221, 'organised local government in the compilation of a list envisaged in subsection
(1) (c).'),
('2', 221, 'Members of the Commission must have appropriate expertise.'),
('3', 221, 'Members serve for a term established in terms of national legislation. The President
may remove a member from office on the ground of misconduct, incapacity or
incompetence.'),

('1', 224, 'The primary object of the South African Reserve Bank is to protect the value of
the currency in the interest of balanced and sustainable economic growth in the
Republic.'),
('2', 224, 'The South African Reserve Bank, in pursuit of its primary object, must perform its
functions independently and without fear, favour or prejudice, but there must be
regular consultation between the Bank and the Cabinet member responsible for
national financial matters.'),

('1', 226, 'There is a Provincial Revenue Fund for each province into which all money received
by the provincial government must be paid, except money reasonably excluded by
an Act of Parliament.'),
('2', 226, 'Money may be withdrawn from a Provincial Revenue Fund only—'),
('2a', 226, 'in terms of an appropriation by a provincial Act; or'),
('2b', 226, 'as a direct charge against the Provincial Revenue Fund, when it is provided for
in the Constitution or a provincial Act.'),
('3', 226, 'Revenue allocated through a province to local government in that province in terms
of section 214(1), is a direct charge against that province’s Revenue Fund.'),
('4', 226, 'National legislation may determine a framework within which—'),
('4a', 226, 'a provincial Act may in terms of subsection (2)(b) authorise the withdrawal of
money as a direct charge against a Provincial Revenue Fund; and'),
('4b', 226, 'revenue allocated through a province to local government in that province in
terms of subsection (3) must be paid to municipalities in the province.'),

('1', 227, 'Local government and each province—'),
('1a', 227, 'is entitled to an equitable share of revenue raised nationally to enable it to
provide basic services and perform the functions allocated to it; and'),
('1b', 227, 'may receive other allocations from national government revenue, either
conditionally or unconditionally.'),
('2', 227, 'Additional revenue raised by provinces or municipalities may not be deducted from
their share of revenue raised nationally, or from other allocations made to them
out of national government revenue. Equally, there is no obligation on the national
government to compensate provinces or municipalities that do not raise revenue
commensurate with their fiscal capacity and tax base.'),
('3', 227, 'A province’s equitable share of revenue raised nationally must be transferred to
the province promptly and without deduction, except when the transfer has been
stopped in terms of section 216.'),
('4', 227, 'A province must provide for itself any resources that it requires, in terms of a
provision of its provincial constitution, that are additional to its requirements
envisaged in the Constitution.'),

('1', 228, 'A provincial legislature may impose—'),
('1a', 228, 'taxes, levies and duties other than income tax, value-added tax, general sales
tax, rates on property or customs duties; and'),
('1b', 228, 'flat-rate surcharges on any tax, levy or duty that is imposed by national
legislation, other than on corporate income tax, value-added tax, rates on
property or customs duties.'),
('2', 228, 'The power of a provincial legislature to impose taxes, levies, duties and
surcharges—'),
('2a', 228, 'may not be exercised in a way that materially and unreasonably prejudices
national economic policies, economic activities across provincial boundaries, or
the national mobility of goods, services, capital or labour; and'),
('2b', 228, 'must be regulated in terms of an Act of Parliament, which may be enacted only
after any recommendations of the Financial and Fiscal Commission have been
considered.'),

('1', 229, 'Subject to subsections (2), (3) and (4), a municipality may impose—'),
('1a', 229, 'rates on property and surcharges on fees for services provided by or on behalf
of the municipality; and'),
('1b', 229, 'if authorised by national legislation, other taxes, levies and duties
appropriate to local government or to the category of local government into
which that municipality falls, but no municipality may impose income tax,
value-added tax, general sales tax or customs duty.'),
('2', 229, 'The power of a municipality to impose rates on property, surcharges on fees for
services provided by or on behalf of the municipality, or other taxes, levies or
duties—'),
('2a', 229, 'may not be exercised in a way that materially and unreasonably prejudices
national economic policies, economic activities across municipal boundaries, or
the national mobility of goods, services, capital or labour; and'),
('2b', 229, 'may be regulated by national legislation.'),
('3', 229, 'When two municipalities have the same fiscal powers and functions with regard to
the same area, an appropriate division of those powers and functions must be made
in terms of national legislation. The division may be made only after taking into
account at least the following criteria:'),
('3a', 229, 'The need to comply with sound principles of taxation.'),
('3b', 229, 'The powers and functions performed by each municipality.'),
('3c', 229, 'The fiscal capacity of each municipality.'),
('3d', 229, 'The effectiveness and efficiency of raising taxes, levies and duties.'),
('3e', 229, 'Equity.'),
('4', 229, 'Nothing in this section precludes the sharing of revenue raised in terms of this
section between municipalities that have fiscal power and functions in the same
area.'),
('5', 229, 'National legislation envisaged in this section may be enacted only after organised
local government and the Financial and Fiscal Commission have been consulted, and
any recommendations of the Commission have been considered.'),

('1', 230, 'A province may raise loans for capital or current expenditure in accordance with
national legislation, but loans for current expenditure may be raised only when
necessary for bridging purposes during a fiscal year.'),
('2', 230, 'National legislation referred to in subsection (1) may be enacted only after any
recommendations of the Financial and Fiscal Commission have been considered.'),

('1', 23065, 'A Municipal Council may, in accordance with national legislation—'),
('1a', 23065, 'raise loans for capital or current expenditure for the municipality, but loans for
current expenditure may be raised only when necessary for bridging purposes
during a fiscal year; and'),
('1b', 23065, 'bind itself and a future Council in the exercise of its legislative and executive
authority to secure loans or investments for the municipality.'),
('2', 23065, 'National legislation referred to in subsection (1) may be enacted only after any
recommendations of the Financial and Fiscal Commission have been considered.');
GO

/* /////////////// Chapter 14's contents /////////// */
INSERT INTO [MainSchema].Sections (SectionID, ChapterID, SectionTitle, SectionText)
VALUES
(231, 14, 'International agreements', NULL),
(232, 14, 'Customary international law', 'Customary international law is law in the Republic unless it is inconsistent with the Constitution or an Act of Parliament.'),
(233, 14, 'Application of international law', 'When interpreting any legislation, every court must prefer any reasonable interpretation
of the legislation that is consistent with international law over any alternative
interpretation that is inconsistent with international law.'),
(234, 14, 'Charters of Rights', 'In order to deepen the culture of democracy established by the Constitution, Parliament
may adopt Charters of Rights consistent with the provisions of the Constitution.'),
(235, 14, 'Self-determination', 'The right of the South African people as a whole to self-determination, as manifested in
this Constitution, does not preclude, within the framework of this right, recognition of the
notion of the right of self-determination of any community sharing a common cultural
and language heritage, within a territorial entity in the Republic or in any other way,
determined by national legislation.'),
(236, 14, 'Funding for political parties', 'To enhance multi-party democracy, national legislation must provide for the funding of
political parties participating in national and provincial legislatures on an equitable and
proportional basis.'),
(237, 14, 'Diligent performance of obligations', 'All constitutional obligations must be performed diligently and without delay.'),
(238, 14, 'Agency and delegation', NULL),
(239, 14, 'Definitions', NULL),
(240, 14, 'Inconsistencies between different texts', 'In the event of an inconsistency between different texts of the Constitution, the English text prevails.'),
(241, 14, 'Transitional arrangements', 'Schedule 6 applies to the transition to the new constitutional order established by this
Constitution, and any matter incidental to that transition.'),
(242, 14, 'Repeal of laws', 'The laws mentioned in Schedule 7 are repealed, subject to section 243 and Schedule 6.'),
(243, 14, 'Short title and commencement', NULL);

INSERT INTO [MainSchema].Subsections(SubsectionID, SectionID, SubsectionText)
VALUES
('1', 231, 'The negotiating and signing of all international agreements is the responsibility of
the national executive.'),
('2', 231, 'An international agreement binds the Republic only after it has been approved by
resolution in both the National Assembly and the National Council of Provinces,
unless it is an agreement referred to in subsection (3).'),
('3', 231, 'An international agreement of a technical, administrative or executive nature, or
an agreement which does not require either ratification or accession, entered into
by the national executive, binds the Republic without approval by the National
Assembly and the National Council of Provinces, but must be tabled in the Assembly
and the Council within a reasonable time.'),
('4', 231, 'Any international agreement becomes law in the Republic when it is enacted into
law by national legislation; but a self-executing provision of an agreement that has
been approved by Parliament is law in the Republic unless it is inconsistent with the
Constitution or an Act of Parliament.'),
('5', 231, 'The Republic is bound by international agreements which were binding on the
Republic when this Constitution took effect.'),

('0', 238, 'An executive organ of state in any sphere of government may—'),
('0a', 238, 'delegate any power or function that is to be exercised or performed in terms
of legislation to any other executive organ of state, provided the delegation is
consistent with the legislation in terms of which the power is exercised or the
function is performed; or'),
('0b', 238, 'exercise any power or perform any function for any other executive organ of
state on an agency or delegation basis.'),

('0', 239, 'In the Constitution, unless the context indicates otherwise—'),
('1', 239, '“national legislation” includes—'),
('1a', 239, 'subordinate legislation made in terms of an Act of Parliament; and'),
('1b', 239, 'legislation that was in force when the Constitution took effect and that is
administered by the national government;'),
('2', 239, '“organ of state” means—'),
('2a', 239, 'any department of state or administration in the national, provincial or local
sphere of government; or'),
('2b', 239, 'any other functionary or institution—'),
('3', 239, '“provincial legislation” includes—'),
('3a', 239, 'subordinate legislation made in terms of a provincial Act; and'),
('3b', 239, 'legislation that was in force when the Constitution took effect and that is
administered by a provincial government.'),

('1', 243, 'This Act is called the Constitution of the Republic of South Africa, 1996, and comes
into effect as soon as possible on a date set by the President by proclamation, which
may not be a date later than 1 July 1997.'),
('2', 243, 'The President may set different dates before the date mentioned in subsection (1) in
respect of different provisions of the Constitution.'),
('3', 243, 'Unless the context otherwise indicates, a reference in a provision of the Constitution
to a time when the Constitution took effect must be construed as a reference to the
time when that provision took effect.'),
('4', 243, 'If a different date is set for any particular provision of the Constitution in terms of
subsection (2), any corresponding provision of the Constitution of the Republic of
South Africa, 1993 (Act 200 of 1993), mentioned in the proclamation, is repealed
with effect from the same date.'),
('5', 243, 'Sections 213, 214, 215, 216, 218, 226, 227, 228, 229 and 230 come into effect on 1
January 1998, but this does not preclude the enactment in terms of this Constitution
of legislation envisaged in any of these provisions before that date. Until that date
any corresponding and incidental provisions of the Constitution of the Republic of
South Africa, 1993, remain in force.');
GO


INSERT INTO [MainSchema].Clauses(ClauseID, SectionID, SubsectionID, ClauseText)
VALUES
('i', 239, '2b', 'exercising a power or performing a function in terms of the Constitution
or a provincial constitution; or'),
('ii', 239, '2b', 'exercising a public power or performing a public function in terms of any
legislation, but does not include a court or a judicial officer;');
/* END OF MAINSCHEMA */ 



/* 
	//////////////// 
	AmendmentSchema 
	/////////////// 
*/

INSERT INTO AmendmentSchema.Amendments
VALUES
(1, 'Constitution First Amendment Act of 1997', '1997-02-04', 's.4 of the Constitution First Amendment Act of 1997'),
(2, 'Constitution Second Amendment Act of 1998', '1998-10-07', 's.6 of the Constitution Second Amendment Act of 1998'),
(3, 'Constitution Third Amendment Act of 1998', '1998-10-30', 's.3 of the Constitution Third Amendment Act of 1998'),
(4, 'Constitution Fourth Amendment Act of 1999', '1999-03-19', 's.3 of the Constitution Fourth Amendment Act of 1999'),
(5, 'Constitution Fifth Amendment Act of 1999', '1999-03-19', 's.3 of the Constitution Fifth Amendment Act of 1999'),
(6, 'Constitution Sixth Amendment Act of 2001', '2001-11-21', 's.21 of the Constitution Sixth Amendment Act of 2001'),
(7, 'Constitution Seventh Amendment Act of 2001', '2003-12-01', 's.11 of the Constitution Seventh Amendment Act of 2001; Proc R32 in GG 23364 of 26 April 2002; Proc 77 in GG 25792 of 1 December 2003'),
(8, 'Constitution Eighth Amendment Act of 2002', '2002-06-20', 's.3 of the Constitution Eighth Amendment Act of 2002'),
(9, 'Constitution Ninth Amendment Act of 2002', '2002-06-20', 's.4 of the Constitution Ninth Amendment Act of 2002'),
(10, 'Constitution Tenth Amendment Act of 2003', '2003-03-20', 's.10 of the Constitution Tenth Amendment Act of 2003; Proc R22 in GG 24698 of 20 March 2003'),
(11, 'Constitution Eleventh Amendment Act of 2003', '2003-07-11', 's.5 of the Constitutional Eleventh Amendment Act of 2003; Proc R53 in GG 25206 of 11 July 2003'),
(12, 'Constitution Twelfth Amendment Act of 2005', '2006-03-01', 's.5 of the Constitution Twelfth Amendment Act of 2005; Proc R8 in GG 28568 of 27 February 2008'),
(13, 'Citation of Constitutional Laws Act 5 of 2005', '2005-06-27', 's.5 of Act 5 of 2005'),
(14, 'Constitution Thirteenth Amendment Act of 2007', '2007-12-14', 's.2 of the Constitution Thirteenth Amendment Act of 2007'),
(15, 'Constitution Fourteenth Amendment Act of 2008', '2009-04-17', 's.7 of the Constitution Fourteenth Amendment Act of 2008; Proc R21 in GG 32130 of 16 April 2009'),
(16, 'Constitution Fifteenth Amendment Act of 2008', '2009-04-17', 's.6 of the Constitution Fifteenth Amendment Act of 2008; Proc R22 in GG 32130 of 16 April 2009'),
(17, 'Constitution Sixteenth Amendment Act of 2009', '2009-04-03', 's.2 of the Constitution Sixteenth Amendment Act of 2009; Proc R20 in GG 32091 of 2 April 2009'),
(18, 'South African Police Service Amendment Act 10 of 2012', '2012-09-14', 's.22 of Act 10 of 2012; Proc 52 in GG 35695 of 14 September 2012'),
(19, 'Constitution Seventeenth Amendment Act of 2012', '2013-08-23', 's.11 of the Constitution Seventeenth Amendment Act of 2012; Proc R35 in GG 36774 of 22 August 2013'),
(20, 'Constitution Eighteenth Amendment Act of 2023', '2023-07-27', 's.1 of the Constitution Eighteenth Amendment Act of 2023; GG 49041 of 27 July 2023');
GO

/* END OF AMENDMENTSCHEMA */ 




/* 
	//////////////// 
	ScheduleSchema 
	/////////////// 
*/

/* /////////////// Schedule 1's contents /////////// */
INSERT INTO [ScheduleSchema].ScheduleOne_NationalFlag (SectionID, SectionText)
VALUES
(1, 'The national flag is rectangular; it is one and a half times longer than it is wide.'),
(2, 'It is black, gold, green, white, chilli red and blue.'),
(3, 'It has a green Y-shaped band that is one fifth as wide as the flag. The centre lines of the
band start in the top and bottom corners next to the flag post, converge in the centre of
the flag, and continue horizontally to the middle of the free edge.'),
(4, 'The green band is edged, above and below in white, and towards the flag post end, in
gold. Each edging is one fifteenth as wide as the flag.'),
(5, 'The triangle next to the flag post is black.'),
(6, 'The upper horizontal band is chilli red and the lower horizontal band is blue. These bands
are each one third as wide as the flag.');
GO

/* /////////////// Schedule 1A's contents /////////// */
INSERT INTO [ScheduleSchema].ScheduleOneA_GeoAreasProvinces (Province, MapCSV)
VALUES
('The Province of the Eastern Cape', 'Map No. 3 of Schedule 1 to Notice 1998 of 2005; Map No. 6 of Schedule 2 to Notice 1998 of 2005; Map No. 7 of Schedule 2 to Notice 1998 of 2005; Map No. 8 of Schedule 2 to Notice 1998 of 2005; Map No. 9 of Schedule 2 to Notice 1998 of 2005; Map No. 10 of Schedule 2 to Notice 1998 of 2005; Map No. 11 of Schedule 2 to Notice 1998 of 2005'),
('The Province of the Free State', 'Map No. 12 of Schedule 2 to Notice 1998 of 2005; Map No. 13 of Schedule 2 to Notice 1998 of 2005; Map No. 14 of Schedule 2 to Notice 1998 of 2005; Map No. 15 of Schedule 2 to Notice 1998 of 2005; Map No. 16 of Schedule 2 to Notice 1998 of 2005'),
('The Province of Gauteng', 'Map No. 4 in Notice 1490 of 2008; Map No. 17 of Schedule 2 to Notice 1998 of 2005; Map No. 18 of Schedule 2 to Notice 1998 of 2005; Map No. 19 of Schedule 2 to Notice 1998 of 2005; Map No. 20 of Schedule 2 to Notice 1998 of 2005; Map No. 21 of Schedule 2 to Notice 1998 of 2005'),
('The Province of KwaZulu-Natal', 'Map No. 22 of Schedule 2 to Notice 1998 of 2005; Map No. 23 of Schedule 2 to Notice 1998 of 2005; Map No. 24 of Schedule 2 to Notice 1998 of 2005; Map No. 25 of Schedule 2 to Notice 1998 of 2005; Map No. 26 of Schedule 2 to Notice 1998 of 2005; Map No. 27 of Schedule 2 to Notice 1998 of 2005; Map No. 28 of Schedule 2 to Notice 1998 of 2005; Map No. 29 of Schedule 2 to Notice 1998 of 2005; Map No. 30 of Schedule 2 to Notice 1998 of 2005; Map No. 31 of Schedule 2 to Notice 1998 of 2005; Map No. 32 of Schedule 2 to Notice 1998 of 2005'),
('The Province of Limpopo', 'Map No. 33 of Schedule 2 to Notice 1998 of 2005; Map No. 34 of Schedule 2 to Notice 1998 of 2005; Map No. 35 of Schedule 2 to Notice 1998 of 2005; Map No. 36 of Schedule 2 to Notice 1998 of 2005; Map No. 37 of Schedule 2 to Notice 1998 of 2005'),
('The Province of Mpumalanga', 'Map No. 38 of Schedule 2 to Notice 1998 of 2005; Map No. 39 of Schedule 2 to Notice 1998 of 2005; Map No. 40 of Schedule 2 to Notice 1998 of 2005'),
('The Province of the Northern Cape', 'Map No. 41 of Schedule 2 to Notice 1998 of 2005; Map No. 42 of Schedule 2 to Notice 1998 of 2005; Map No. 43 of Schedule 2 to Notice 1998 of 2005; Map No. 44 of Schedule 2 to Notice 1998 of 2005; Map No. 45 of Schedule 2 to Notice 1998 of 2005'),
('The Province of North West', 'Map No. 5 in Notice 1490 of 2008; Map No. 46 of Schedule 2 to Notice 1998 of 2005; Map No. 47 of Schedule 2 to Notice 1998 of 2005; Map No. 48 of Schedule 2 to Notice 1998 of 2005'),
('The Province of the Western Cape', 'Map No. 49 of Schedule 2 to Notice 1998 of 2005; Map No. 50 of Schedule 2 to Notice 1998 of 2005; Map No. 51 of Schedule 2 to Notice 1998 of 2005; Map No. 52 of Schedule 2 to Notice 1998 of 2005; Map No. 53 of Schedule 2 to Notice 1998 of 2005; Map No. 54 of Schedule 2 to Notice 1998 of 2005');
GO


/* /////////////// Schedule 2's contents /////////// */
INSERT INTO [ScheduleSchema].ScheduleTwo_OathsAffirmations (SectionID, SectionTitle, SectionText)
VALUES
(1, 'Oath or solemn affirmation of President and Acting President', 'The President or Acting President, before the Chief Justice, or another judge designated by
the Chief Justice, must swear/affirm as follows:
In the presence of everyone assembled here, and in full realisation of the high calling
I assume as President/Acting President of the Republic of South Africa, I, A.B., swear/
solemnly affirm that I will be faithful to the Republic of South Africa, and will obey,
observe, uphold and maintain the Constitution and all other law of the Republic; and I
solemnly and sincerely promise that I will always—
• promote all that will advance the Republic, and oppose all that may harm it;
• protect and promote the rights of all South Africans;
• discharge my duties with all my strength and talents to the best of my
knowledge and ability and true to the dictates of my conscience;
• do justice to all; and
• devote myself to the well-being of the Republic and all of its people.
(In the case of an oath: So help me God.)'),
(2, 'Oath or solemn affirmation of Deputy President', 'The Deputy President, before the Chief Justice or another judge designated by the Chief
Justice, must swear/affirm as follows:
In the presence of everyone assembled here, and in full realisation of the high calling I
assume as Deputy President of the Republic of South Africa, I, A.B., swear/solemnly affirm
that I will be faithful to the Republic of South Africa and will obey, observe, uphold and
maintain the Constitution and all other law of the Republic; and I solemnly and sincerely
promise that I will always—
Schedule 2: Oaths and Solemn Affirmations
129
• promote all that will advance the Republic, and oppose all that may harm it;
• be a true and faithful counsellor;
• discharge my duties with all my strength and talents to the best of my
knowledge and ability and true to the dictates of my conscience;
• do justice to all; and
• devote myself to the well-being of the Republic and all of its people.
(In the case of an oath: So help me God.)'),
(3, 'Oath or solemn affirmation of Ministers and Deputy Ministers', 'Each Minister and Deputy Minister, before the Chief Justice or another judge designated by
the Chief Justice, must swear/affirm as follows:
I, A.B., swear/solemnly affirm that I will be faithful to the Republic of South Africa and
will obey, respect and uphold the Constitution and all other law of the Republic; and I
undertake to hold my office as Minister/Deputy Minister with honour and dignity; to
be a true and faithful counsellor; not to divulge directly or indirectly any secret matter
entrusted to me; and to perform the functions of my office conscientiously and to the best
of my ability.
(In the case of an oath: So help me God.)'),
(4, 'Oath or solemn affirmation of members of the National Assembly,
permanent delegates to the National Council of Provinces and members
of the provincial legislatures', NULL),
(5, 'Oath or solemn affirmation of Premiers, Acting Premiers and members
of provincial Executive Councils', 'The Premier or Acting Premier of a province, and each member of the Executive Council of
a province, before the Chief Justice or a judge designated by the Chief Justice, must swear/
affirm as follows:
I, A.B., swear/solemnly affirm that I will be faithful to the Republic of South Africa and
will obey, respect and uphold the Constitution and all other law of the Republic; and I
undertake to hold my office as Premier/Acting Premier/member of the Executive Council
of the province of C.D. with honour and dignity; to be a true and faithful counsellor; not
to divulge directly or indirectly any secret matter entrusted to me; and to perform the
functions of my office conscientiously and to the best of my ability.
(In the case of an oath: So help me God.)'),
(6, 'Oath or solemn affirmation of Judicial Officers', NULL);
GO

INSERT INTO [ScheduleSchema].ScheduleTwo_Subsections (SubsectionID, SectionID, SubsectionText)
VALUES
('1', 4, 'Members of the National Assembly, permanent delegates to the National Council of
Provinces and members of provincial legislatures, before the Chief Justice or a judge
designated by the Chief Justice, must swear or affirm as follows:
I, A.B., swear/solemnly affirm that I will be faithful to the: Republic of South Africa
and will obey, respect and uphold the Constitution and all other law of the Republic;
and I solemnly promise to perform my functions as a member of the National
Assembly/permanent delegate to the National Council of Provinces/member of the
legislature of the province of C.D. to the best of my ability.
(In the case of an oath: So help me God.)'),
('2', 4, 'Persons filling a vacancy in the National Assembly, a permanent delegation to the
National Council of Provinces or a provincial legislature may swear or affirm in terms
of subitem (1) before the presiding officer of the Assembly, Council or legislature, as
the case may be.'),
('1', 6, 'Each judge or acting judge, before the Chief Justice or another judge designated by
the Chief Justice, must swear or affirm as follows:
I, A.B., swear/solemnly affirm that, as a Judge of the Constitutional Court/Supreme
Court of Appeal/High Court/ E.F. Court, I will be faithful to the Republic of South
Africa, will uphold and protect the Constitution and the human rights entrenched in
it, and will administer justice to all persons alike without fear, favour or prejudice, in
accordance with the Constitution and the law.
(In the case of an oath: So help me God.)'),
('2', 6, 'A person appointed to the office of Chief Justice who is not already a judge at the
time of that appointment must swear or affirm before the Deputy Chief Justice, or
failing that judge, the next most senior available judge of the Constitutional Court.'),
('3', 6, 'Judicial officers, and acting judicial officers, other than judges, must swear/affirm in
terms of national legislation.');
GO

/* /////////////// Schedule 3's contents /////////// */
INSERT INTO [ScheduleSchema].ScheduleThree_Parts (PartID, PartName)
VALUES
('A', 'Election Procedures for Constitutional Office-Bearers'),
('B', 'Formula to Determine Party Participation in Provincial Delegations to the National Council of Provinces');
GO

INSERT INTO [ScheduleSchema].ScheduleThree_ElectionProcedures (SectionID, SectionThreePart, SectionTitle, SectionText)
VALUES
(1, 'A', 'Application', NULL),
(2, 'A', 'Nominations', 'The person presiding at a meeting to which this Schedule applies must call for the
nomination of candidates at the meeting.'),
(3, 'A', 'Formal requirements', NULL),
(4, 'A', 'Announcement of names of candidates', 'At a meeting to which this Schedule applies, the person presiding must announce the
names of the persons who have been nominated as candidates, but may not permit any
debate.'),
(5, 'A', 'Single candidate', 'If only one candidate is nominated, the person presiding must declare that candidate
elected.'),
(6, 'A', 'Election procedure', NULL),
(7, 'A', 'Elimination procedure', NULL),
(8, 'A', 'Further meetings', NULL),
(9, 'A', 'Rules', NULL),
(1, 'B', 'Calculation', 'The number of delegates in a provincial delegation to the National Council of Provinces
to which a party is entitled, must be determined by multiplying the number of seats the
party holds in the provincial legislature by ten and dividing the result by the number of
seats in the legislature plus one.'),
(2, 'B', 'Surplus protocol', 'If a calculation in terms of item 1 yields a surplus not absorbed by the delegates allocated
to a party in terms of that item, the surplus must compete with similar surpluses accruing
to any other party or parties, and any undistributed delegates in the delegation must be
allocated to the party or parties in the sequence of the highest surplus.'),
(3, 'B', 'Surplus protocol 2', 'If the competing surpluses envisaged in item 2 are equal, the undistributed delegates
in the delegation must be allocated to the party or parties with the same surplus in the
sequence from the highest to the lowest number of votes that have been recorded for
those parties during the last election for the provincial legislature concerned.'),
(4, 'B', 'Surplus protocol 3', 'If more than one party with the same surplus recorded the same number of votes during
the last election for the provincial legislature concerned, the legislature concerned must
allocate the undistributed delegates in the delegation to the party with the same surplus
in a manner which is consistent with democracy.');
GO

INSERT INTO [ScheduleSchema].ScheduleThree_Subsections (SubsectionID, SectionID, SectionThreePart, SectionText)
VALUES
('0', 1, 'A', 'The procedure set out in this Schedule applies whenever—'),
('0a', 1, 'A', 'the National Assembly meets to elect the President, or the Speaker or Deputy
Speaker of the Assembly;'),
('0b', 1, 'A', 'the National Council of Provinces meets to elect its Chairperson or a Deputy
Chairperson; or'),
('0c', 1, 'A', 'a provincial legislature meets to elect the Premier of the province or the
Speaker or Deputy Speaker of the legislature.'),

('1', 3, 'A', 'A nomination must be made on the form prescribed by the rules mentioned in item
9.'),
('2', 3, 'A', 'The form on which a nomination is made must be signed—'),
('2a', 3, 'A', 'by two members of the National Assembly, if the President or the Speaker or
Deputy Speaker of the Assembly is to be elected;'),
('2b', 3, 'A', 'on behalf of two provincial delegations, if the Chairperson or a Deputy
Chairperson of the National Council of Provinces is to be elected; or'),
('2c', 3, 'A', 'by two members of the relevant provincial legislature, if the Premier of the
province or the Speaker or Deputy Speaker of the legislature is to be elected.'),
('3', 3, 'A', 'A person who is nominated must indicate acceptance of the nomination by signing
either the nomination form or any other form of written confirmation.'),

('0', 6, 'A', 'If more than one candidate is nominated—'),
('0a', 6, 'A', 'a vote must be taken at the meeting by secret ballot;'),
('0b', 6, 'A', 'each member present, or if it is a meeting of the National Council of Provinces,
each province represented, at the meeting may cast one vote; and'),
('0c', 6, 'A', 'the person presiding must declare elected the candidate who receives a
majority of the votes.'),

('1', 7, 'A', 'If no candidate receives a majority of the votes, the candidate who receives the
lowest number of votes must be eliminated and a further vote taken on the
remaining candidates in accordance with item 6. This procedure must be repeated
until a candidate receives a majority of the votes.'),
('2', 7, 'A', 'When applying subitem (1), if two or more candidates each have the lowest number
of votes, a separate vote must be taken on those candidates, and repeated as often
as may be necessary to determine which candidate is to be eliminated.'),

('1', 8, 'A', 'If only two candidates are nominated, or if only two candidates remain
after an elimination procedure has been applied, and those two candidates receive
the same number of votes, a further meeting must be held within seven days, at a
time determined by the person presiding.'),
('2', 8, 'A', 'If a further meeting is held in terms of subitem (1), the procedure prescribed in
this Schedule must be applied at that meeting as if it were the first meeting for the
election in question.'),

('1', 9, 'A', 'The Chief Justice must make rules prescribing—'),
('1a', 9, 'A', 'the procedure for meetings to which this Schedule applies;'),
('1b', 9, 'A', 'the duties of any person presiding at a meeting, and of any person assisting
the person presiding;'),
('1c', 9, 'A', 'the form on which nominations must be submitted; and'),
('1d', 9, 'A', 'the manner in which voting is to be conducted.'),
('2', 9, 'A', 'These rules must be made known in the way that the Chief Justice determines.');
GO

/* /////////////// Schedule 4's contents /////////// */
INSERT INTO [ScheduleSchema].ScheduleFour_ConcurrentCompetencies (PartID, PartCSV)
VALUES
('A', 'Administration of indigenous forests; Agriculture; Airports other than international and national airports; Animal control and diseases; Casinos, racing, gambling and wagering, excluding lotteries and sports pools; Consumer protection; Cultural matters; Disaster management; Education at all levels, excluding tertiary education; Environment; Health services; Housing; Indigenous law and customary law, subject to Chapter 12 of the Constitution; Industrial promotion; Language policy and the regulation of official languages to the extent that the provisions of section 6 of the Constitution expressly confer upon the provincial legislatures legislative competence; Media services directly controlled or provided by the provincial government, subject to section 192; Nature conservation, excluding national parks, national botanical gardens and marine resources; Police to the extent that the provisions of Chapter 11 of the Constitution confer upon the provincial legislatures legislative competence; Pollution control; Population development; Property transfer fees; Provincial public enterprises in respect of the functional areas in this Schedule and Schedule 5; Public transport; Public works only in respect of the needs of provincial government departments in the discharge of their responsibilities to administer functions specifically assigned to them in terms of the Constitution or any other law; Regional planning and development; Road traffic regulation; Soil conservation; Tourism; Trade; Traditional leadership, subject to Chapter 12 of the Constitution; Urban and rural development; Vehicle licensing; Welfare services'),
('B', 'Air pollution; Building regulations; Child care facilities; Electricity and gas reticulation; Firefighting services; Local tourism; Municipal airports; Municipal planning; Municipal health services; Municipal public transport; Municipal public works only in respect of the needs of municipalities in the discharge of their responsibilities to administer functions specifically assigned to them under this Constitution or any other law; Pontoons, ferries, jetties, piers and harbours, excluding the regulation of international and national shipping and matters related thereto; Stormwater management systems in built-up areas; Trading regulations; Water and sanitation services limited to potable water supply systems and domestic waste-water and sewage disposal systems');
GO

/* /////////////// Schedule 5's contents /////////// */
INSERT INTO [ScheduleSchema].ScheduleFive_ExclusiveProvincialCompetencies (PartID, PartCSV)
VALUES
('A', 'Abattoirs; Ambulance services; Archives other than national archives; Libraries other than national libraries; Liquor licences; Museums other than national museums; Provincial planning; Provincial cultural matters; Provincial recreation and amenities; Provincial sport; Provincial roads and traffic; Veterinary services, excluding regulation of the profession'),
('B', 'Beaches and amusement facilities; Billboards and the display of advertisements in public places; Cemeteries, funeral parlours and crematoria; Cleansing; Control of public nuisances; Control of undertakings that sell liquor to the public; Facilities for the accommodation, care and burial of animals; Fencing and fences; Licensing of dogs; Licensing and control of undertakings that sell food to the public; Local amenities; Local sport facilities; Markets; Municipal abattoirs; Municipal parks and recreation; Municipal roads; Noise pollution; Pounds; Public places; Refuse removal, refuse dumps and solid waste disposal; Street trading; Street lighting; Traffic and parking');
GO

/* /////////////// Schedule 6's contents /////////// */
INSERT INTO [ScheduleSchema].ScheduleSix_TransitionalArrangements(SectionID, SectionTitle, SectionText)
VALUES
(1, 'Definitions', 'In this Schedule, unless inconsistent with the context—
“homeland” means a part of the Republic which, before the previous Constitution took
effect, was dealt with in South African legislation as an independent or a self-governing
territory;
“new Constitution” means the Constitution of the Republic of South Africa, 1996;
“old order legislation” means legislation enacted before the previous Constitution took
effect;
“previous Constitution” means the Constitution of the Republic of South Africa, 1993 (Act
200 of 1993).'),
(2, 'Continuation of existing law', NULL),
(3, 'Interpretation of existing legislation', NULL),
(4, 'National Assembly', NULL),
(5, 'Unfinished business before Parliament', NULL),
(6, 'Elections of National Assembly', NULL),
(7, 'National Council of Provinces', NULL),
(8, 'Former senators', NULL),
(9, 'National executive', NULL),
(10, 'Provincial legislatures', NULL),
(11, 'Elections of provincial legislatures', NULL),
(12, 'Provincial executives', NULL),
(13, 'Provincial constitutions', 'A provincial constitution passed before the new Constitution took effect must comply with
section 143 of the new Constitution.'),
(14, 'Assignment of legislation to provinces', NULL),
(15, 'Existing legislation outside Parliament’s legislative power', NULL),
(16, 'Courts', NULL),
(17, 'Cases pending before courts', 'All proceedings which were pending before a court when the new Constitution took effect,
must be disposed of as if the new Constitution had not been enacted, unless the interests
of justice require otherwise.'),
(18, 'Prosecuting authority', NULL),
(19, 'Oaths and affirmations', 'A person who continues in office in terms of this Schedule and who has taken the oath of
office or has made a solemn affirmation under the previous Constitution, is not obliged to
repeat the oath of office or solemn affirmation under the new Constitution.'),
(20, 'Other constitutional institutions', NULL),
(21, 'Enactment of legislation required by new Constitution', NULL),
(22, 'National unity and reconciliation', NULL),
(23, 'Bill of Rights', NULL),
(24, 'Public administration and security services', NULL),
(25, 'Additional disqualification for legislatures', NULL),
(26, 'Local government', NULL),
(27, 'Safekeeping of Acts of Parliament and Provincial Acts', 'Sections 82 and 124 of the new Constitution do not affect the safekeeping of Acts of
Parliament or provincial Acts passed before the new Constitution took effect.'),
(28, 'Registration of immovable property owned by the state', NULL),
(29, 'Schedule 6A', 'Inserted by s. 6 of Constitution Tenth Amendment Act of 2003 and repealed by s. 6 of the
Constitution Fourteenth Amendment Act of 2008.'),
(30, 'Schedule 6B', 'Previously Schedule 6A, inserted by s. 2 of the Constitution Eighth Amendment Act
of 2002, amended by s. 5 of the Constitution Tenth Amendment Act of 2003, renumbered by s. 6 of
the Constitution Tenth Amendment Act of 2003 and repealed by s. 5 of the Constitution Fifteenth
Amendment Act of 2008.');
GO

INSERT INTO [ScheduleSchema].ScheduleSix_Subsections(SubsectionID, SectionID, SubsectionText)
VALUES
('1', 2, 'All law that was in force when the new Constitution took effect, continues in force,
subject to—'),
('1a', 2, 'any amendment or repeal; and'),
('1b', 2, 'consistency with the new Constitution.'),
('2', 2, 'Old order legislation that continues in force in terms of subitem (1)—'),
('2a', 2, 'does not have a wider application, territorially or otherwise, than it had before
the previous Constitution took effect unless subsequently amended to have a
wider application; and'),
('2b', 2, 'continues to be administered by the authorities that administered it when the
new Constitution took effect, subject to the new Constitution.'),

('1', 3, 'Unless inconsistent with the context or clearly inappropriate, a reference in any
legislation that existed when the new Constitution took effect—'),
('1a', 3, 'to the Republic of South Africa or a homeland (except when it refers to a
territorial area), must be construed as a reference to the Republic of South
Africa under the new Constitution;'),
('1b', 3, 'to Parliament, the National Assembly or the Senate, must be construed as
a reference to Parliament, the National Assembly or the National Council of
Provinces under the new Constitution;'),
('1c', 3, 'to the President, an Executive Deputy President, a Minister, a Deputy Minister
or the Cabinet, must be construed as a reference to the President, the Deputy
President, a Minister, a Deputy Minister or the Cabinet under the new
Constitution, subject to item 9 of this Schedule;'),
('1d', 3, 'to the President of the Senate, must be construed as a reference to the
Chairperson of the National Council of Provinces;'),
('1e', 3, 'to a provincial legislature, Premier, Executive Council or member of an
Executive Council of a province, must be construed as a reference to a provincial
legislature, Premier, Executive Council or member of an Executive Council
under the new Constitution, subject to item 12 of this Schedule; or'),
('1f', 3, 'to an official language or languages, must be construed as a reference to any of
the official languages under the new Constitution.'),
('2', 3, 'Unless inconsistent with the context or clearly inappropriate, a reference in any
remaining old order legislation—'),
('2a', 3, 'to a Parliament, a House of a Parliament or a legislative assembly or body of
the Republic or of a homeland, must be construed as a reference to—'),
('2b', 3, 'to a State President, Chief Minister, Administrator or other chief executive,
Cabinet, Ministers’ Council or executive council of the Republic or of a
homeland, must be construed as a reference to—'),

('1', 4, 'Anyone who was a member or office-bearer of the National Assembly when the
new Constitution took effect, becomes a member or office-bearer of the National
Assembly under the new Constitution, and holds office as a member or office-bearer
in terms of the new Constitution.'),
('2', 4, 'The National Assembly as constituted in terms of subitem (1) must be regarded as
having been elected under the new Constitution for a term that expires on 30 April
1999.'),
('3', 4, 'The National Assembly consists of 400 members for the duration of its term that
expires on 30 April 1999, subject to section 49(4) of the new Constitution.'),
('4', 4, 'The rules and orders of the National Assembly in force when the new Constitution
took effect, continue in force, subject to any amendment or repeal.'),

('1', 5, 'Any unfinished business before the National Assembly when the new Constitution
takes effect must be proceeded with in terms of the new Constitution.'),
('2', 5, 'Any unfinished business before the Senate when the new Constitution takes effect
must be referred to the National Council of Provinces, and the Council must proceed
with that business in terms of the new Constitution.'),

('1', 6, 'No election of the National Assembly may be held before 30 April 1999 unless the
Assembly is dissolved in terms of section 50(2) after a motion of no confidence in
the President in terms of section 102(2) of the new Constitution.'),
('2', 6, 'Section 50(1) of the new Constitution is suspended until 30 April 1999.'),
('3', 6, 'Despite the repeal of the previous Constitution, Schedule 2 to that Constitution, as
amended by Annexure A to this Schedule, applies—'),
('3a', 6, 'to the first election of the National Assembly under the new Constitution;'),
('3b', 6, 'to the loss of membership of the Assembly in circumstances other than those
provided for in section 47(3) of the new Constitution; and'),
('3c', 6, 'to the filling of vacancies in the Assembly, and the supplementation, review
and use of party lists for the filling of vacancies, until the second election of the
Assembly under the new Constitution.'),
('4', 6, 'Section 47(4) of the new Constitution is suspended until the second election of the
National Assembly under the new Constitution.'),

('1', 7, 'For the period which ends immediately before the first sitting of a provincial
legislature held after its first election under the new Constitution—'),
('1a', 7, 'the proportion of party representation in the province’s delegation to the
National Council of Provinces must be the same as the proportion in which the
province’s 10 senators were nominated in terms of section 48 of the previous
Constitution; and'),
('1b', 7, 'the allocation of permanent delegates and special delegates to the parties
represented in the provincial legislature, is as follows:

PROVINCE;DELEGATE TYPE;PARTY;COUNT
Eastern Cape;Permanent;ANC;5
Eastern Cape;Permanent;NP;1
Eastern Cape;Special;ANC;4
Free State;Permanent;ANC;4
Free State;Permanent;FF;1
Free State;Permanent;NP;1
Free State;Special;ANC;4
Gauteng;Permanent;ANC;3
Gauteng;Permanent;DP;1
Gauteng;Permanent;FF;1
Gauteng;Permanent;NP;1
Gauteng;Special;ANC;3
Gauteng;Special;NP;1
KwaZulu-Natal;Permanent;ANC;1
KwaZulu-Natal;Permanent;DP;1
KwaZulu-Natal;Permanent;IFP;3
KwaZulu-Natal;Permanent;NP;1
KwaZulu-Natal;Special;ANC;2
KwaZulu-Natal;Special;IFP;2
Mpumalanga;Permanent;ANC;4
Mpumalanga;Permanent;FF;1
Mpumalanga;Permanent;NP;1
Mpumalanga;Special;ANC;4
Northern Cape;Permanent;ANC;3
Northern Cape;Permanent;FF;1
Northern Cape;Permanent;NP;2
Northern Cape;Special;ANC;2
Northern Cape;Special;NP;2
Northern Province;Permanent;ANC;6
Northern Province;Special;ANC;4
North West;Permanent;ANC;4
North West;Permanent;FF;1
North West;Permanent;NP;1
North West;Special;ANC;4
Western Cape;Permanent;ANC;2
Western Cape;Permanent;DP;1
Western Cape;Permanent;NP;3
Western Cape;Special;ANC;1
Western Cape;Special;NP;3
'),
('2', 7, 'A party represented in a provincial legislature—'),
('2a', 7, 'must nominate its permanent delegates from among the persons who were
senators when the new Constitution took effect and are available to serve as
permanent delegates; and'),
('2b', 7, 'may nominate other persons as permanent delegates only if none or an
insufficient number of its former senators are available.'),
('3', 7, 'A provincial legislature must appoint its permanent delegates in accordance with
the nominations of the parties.'),
('4', 7, 'Subitems (2) and (3) apply only to the first appointment of permanent delegates to
the National Council of Provinces.'),
('5', 7, 'Section 62(1) of the new Constitution does not apply to the nomination and
appointment of former senators as permanent delegates in terms of this item.'),
('6', 7, '6) The rules and orders of the Senate in force when the new Constitution took effect,
must be applied in respect of the business of the National Council to the extent that
they can be applied, subject to any amendment or repeal.'),

('1', 8, 'A former senator who is not appointed as a permanent delegate to the National
Council of Provinces is entitled to become a full voting member of the legislature of
the province from which that person was nominated as a senator in terms of section
48 of the previous Constitution.'),
('2', 8, 'If a former senator elects not to become a member of a provincial legislature
that person is regarded as having resigned as a senator the day before the new
Constitution took effect.'),
('3', 8, 'The salary, allowances and benefits of a former senator appointed as a permanent
delegate or as a member of a provincial legislature may not be reduced by reason
only of that appointment.'),

('1', 9, 'Anyone who was the President, an Executive Deputy President, a Minister or a
Deputy Minister under the previous Constitution when the new Constitution took
effect, continues in and holds that office in terms of the new Constitution, but
subject to subitem (2).'),
('2', 9, 'Until 30 April 1999, sections 84, 89, 90, 91, 93 and 96 of the new Constitution must
be regarded to read as set out in Annexure B to this Schedule.'),
('3', 9, 'Subitem (2) does not prevent a Minister who was a senator when the new
Constitution took effect, from continuing as a Minister referred to in section 91(1)(a)
of the new Constitution, as that section reads in Annexure B.'),

('1', 10, 'Anyone who was a member or office-bearer of a province’s legislature when the
new Constitution took effect, becomes a member or office-bearer of the legislature
for that province under the new Constitution, and holds office as a member or
office-bearer in terms of the new Constitution and any provincial constitution that
may be enacted.'),
('2', 10, 'A provincial legislature as constituted in terms of subitem (1) must be regarded as
having been elected under the new Constitution for a term that expires on 30 April
1999.'),
('3', 10, 'For the duration of its term that expires on 30 April 1999, and subject to section
108(4), a provincial legislature consists of the number of members determined for
that legislature under the previous Constitution plus the number of former senators
who became members of the legislature in terms of item 8 of this Schedule.'),
('4', 10, 'The rules and orders of a provincial legislature in force when the new Constitution
took effect, continue in force, subject to any amendment or repeal.'),

('1', 11, 'Despite the repeal of the previous Constitution, Schedule 2 to that Constitution, as
amended by Annexure A to this Schedule, applies—'),
('1a', 11, 'to the first election of a provincial legislature under the new Constitution;'),
('1b', 11, 'to the loss of membership of a legislature in circumstances other than those
provided for in section 106(3) of the new Constitution; and'),
('1c', 11, 'to the filling of vacancies in a legislature, and the supplementation, review and
use of party lists for the filling of vacancies, until the second election of the
legislature under the new Constitution.'),
('2', 11, 'Section 106(4) of the new Constitution is suspended in respect of a provincial
legislature until the second election of the legislature under the new Constitution.'),

('1', 12, 'Anyone who was the Premier or a member of the Executive Council of a province
when the new Constitution took effect, continues in and holds that office in terms
of the new Constitution and any provincial constitution that may be enacted, but
subject to subitem (2).'),
('2', 12, 'Until the Premier elected after the first election of a province’s legislature under the
new Constitution assumes office, or the province enacts its constitution, whichever
occurs first, sections 132 and 136 of the new Constitution must be regarded to read
as set out in Annexure C to this Schedule.'),

('1', 14, 'Legislation with regard to a matter within a functional area listed in Schedule 4 or
5 to the new Constitution and which, when the new Constitution took effect, was
administered by an authority within the national executive, may be assigned by the
President, by proclamation, to an authority within a provincial executive designated
by the Executive Council of the province.'),
('2', 14, 'To the extent that it is necessary for an assignment of legislation under subitem (1)
to be effectively carried out, the President, by proclamation, may—'),
('2a', 14, 'amend or adapt the legislation to regulate its interpretation or application;'),
('2b', 14, 'where the assignment does not apply to the whole of any piece of legislation,
repeal and re-enact, with or without any amendments or adaptations referred
to in paragraph (a), those provisions to which the assignment applies or to the
extent that the assignment applies to them; or'),
('2c', 14, 'regulate any other matter necessary as a result of the assignment, including
the transfer or secondment of staff, or the transfer of assets, liabilities, rights
and obligations, to or from the national or a provincial executive or any
department of state, administration, security service or other institution.'),
('3a', 14, 'A copy of each proclamation issued in terms of subitem (1) or (2) must be
submitted to the National Assembly and the National Council of Provinces
within 10 days of the publication of the proclamation.'),
('3b', 14, 'If both the National Assembly and the National Council by resolution
disapprove the proclamation or any provision of it, the proclamation or
provision lapses, but without affecting—'),
('4', 14, 'When legislation is assigned under subitem (1), any reference in the legislation to
an authority administering it, must be construed as a reference to the authority to
which it has been assigned.'),
('5', 14, 'Any assignment of legislation under section 235(8) of the previous Constitution,
including any amendment, adaptation or repeal and re-enactment of any
legislation and any other action taken under that section, is regarded as having
been done under this item.'),

('1', 15, 'An authority within the national executive that administers any legislation falling
outside Parliament’s legislative power when the new Constitution takes effect,
remains competent to administer that legislation until it is assigned to an authority
within a provincial executive in terms of item 14 of this Schedule.'),
('2', 15, 'Subitem (1) lapses two years after the new Constitution took effect.'),

('1', 16, 'Every court, including courts of traditional leaders, existing when the new
Constitution took effect, continues to function and to exercise jurisdiction in terms
of the legislation applicable to it, and anyone holding office as a judicial officer
continues to hold office in terms of the legislation applicable to that office, subject
to—'),
('1a', 16, 'any amendment or repeal of that legislation; and'),
('1b', 16, 'consistency with the new Constitution.'),
('2a', 16, 'The Constitutional Court established by the previous Constitution becomes the
Constitutional Court under the new Constitution.'),
('2b', 16, 'Deleted by s. 20(a) of the Constitution Sixth Amendment Act of 2001.'),
('3a', 16, 'The Appellate Division of the Supreme Court of South Africa becomes the
Supreme Court of Appeal under the new Constitution.'),
('3b', 16, 'Deleted by s. 20(a) of the Constitution Sixth Amendment Act of 2001.'),
('4a', 16, 'A provincial or local division of the Supreme Court of South Africa or a supreme
court of a homeland or a general division of such a court, becomes a High Court
under the new Constitution without any alteration in its area of jurisdiction,
subject to any rationalisation contemplated in subitem (6).'),
('4b', 16, 'Anyone holding office or deemed to hold office as the Judge President, the
Deputy Judge President or a judge of a court referred to in paragraph (a) when
the new Constitution takes effect, becomes the Judge President, the Deputy
Judge President or a judge of such a court under the new Constitution, subject
to any rationalisation contemplated in subitem (6).'),
('5', 16, 'Unless inconsistent with the context or clearly inappropriate, a reference in any
legislation or process to—'),
('5a', 16, 'the Constitutional Court under the previous Constitution, must be construed as
a reference to the Constitutional Court under the new Constitution;'),
('5b', 16, 'the Appellate Division of the Supreme Court of South Africa, must be construed
as a reference to the Supreme Court of Appeal; and'),
('5c', 16, 'a provincial or local division of the Supreme Court of South Africa or a supreme
court of a homeland or general division of that court, must be construed as a
reference to a High Court.'),
('6a', 16, 'As soon as is practical after the new Constitution took effect all courts,
including their structure, composition, functioning and jurisdiction, and all
relevant legislation, must be rationalised with a view to establishing a judicial
system suited to the requirements of the new Constitution.'),
('6b', 16, ''),
('7a', 16, 'Anyone holding office, when the Constitution of the Republic of South Africa
Amendment Act, 2001, takes effect, as—'),
('7b', 16, 'All rules, regulations or directions made by the President of the Constitutional
Court or the Chief Justice in force immediately before the Constitution of the
Republic of South Africa Amendment Act, 2001, takes effect, continue in force
until repealed or amended.'),
('7c', 16, 'Unless inconsistent with the context or clearly inappropriate, a reference in
any law or process to the Chief Justice or to the President of the Constitutional
Court, must be construed as a reference to the Chief Justice as contemplated in
section 167(1) of the new Constitution.'),

('1', 18, 'Section 108 of the previous Constitution continues in force until the Act of
Parliament envisaged in section 179 of the new Constitution takes effect. This
subitem does not affect the appointment of the National Director of Public
Prosecutions in terms of section 179.'),
('2', 18, 'An attorney-general holding office when the new Constitution takes effect,
continues to function in terms of the legislation applicable to that office, subject to
subitem (1).'),

('1', 20, 'In this section “constitutional institution” means—'),
('1a', 20, 'the Public Protector;'),
('1b', 20, 'the South African Human Rights Commission;'),
('1c', 20, 'the Commission on Gender Equality;'),
('1d', 20, 'the Auditor-General;'),
('1e', 20, 'the South African Reserve Bank;'),
('1f', 20, 'the Financial and Fiscal Commission;'),
('1g', 20, 'the Judicial Service Commission; or'),
('1h', 20, 'the Pan South African Language Board.'),
('2', 20, 'A constitutional institution established in terms of the previous Constitution
continues to function in terms of the legislation applicable to it, and anyone holding
office as a commission member, a member of the board of the Reserve Bank or the
Pan South African Language Board, the Public Protector or the Auditor-General
when the new Constitution takes effect, continues to hold office in terms of the
legislation applicable to that office, subject to—'),
('2a', 20, 'any amendment or repeal of that legislation; and'),
('2b', 20, 'consistency with the new Constitution.'),
('3', 20, 'Sections 199(1), 200(1), (3) and (5) to (11) and 201 to 206 of the previous
Constitution continue in force until repealed by an Act of Parliament passed in terms
of section 75 of the new Constitution.'),
('4', 20, 'The members of the Judicial Service Commission referred to in section 105(1)(h)
of the previous Constitution cease to be members of the Commission when the
members referred to in section 178(1)(i) of the new Constitution are appointed.'),
('5a', 20, 'The Volkstaat Council established in terms of the previous Constitution
continues to function in terms of the legislation applicable to it, and anyone
holding office as a member of the Council when the new Constitution takes
effect, continues to hold office in terms of the legislation applicable to that
office, subject to—'),
('5b', 20, 'Sections 184A and 184B (1)(a), (b) and (d) of the previous Constitution
continue in force until repealed by an Act of Parliament passed in terms of
section 75 of the new Constitution.'),


('1', 21, 'Where the new Constitution requires the enactment of national or provincial
legislation, that legislation must be enacted by the relevant authority within a
reasonable period of the date the new Constitution took effect.'),
('2', 21, 'Section 198(b) of the new Constitution may not be enforced until the legislation
envisaged in that section has been enacted.'),
('3', 21, 'Section 199(3)(a) of the new Constitution may not be enforced before the expiry of
three months after the legislation envisaged in that section has been enacted.'),
('4', 21, 'National legislation envisaged in section 217(3) of the new Constitution must
be enacted within three years of the date on which the new Constitution took
effect, but the absence of this legislation during this period does not prevent the
implementation of the policy referred to in section 217(2).'),
('5', 21, 'Until the Act of Parliament referred to in section 65(2) of the new Constitution
is enacted each provincial legislature may determine its own procedure in terms
of which authority is conferred on its delegation to cast votes on its behalf in the
National Council of Provinces.'),
('6', 21, 'Until the legislation envisaged in section 229(1)(b) of the new Constitution is
enacted, a municipality remains competent to impose any tax, levy or duty which
it was authorised to impose when the Constitution took effect.'),

('1', 22, 'Notwithstanding the other provisions of the new Constitution and despite the
repeal of the previous Constitution, all the provisions relating to amnesty contained
in the previous Constitution under the heading “National Unity and Reconciliation”
are deemed to be part of the new Constitution for the purposes of the Promotion of
National Unity and Reconciliation Act, 1995 (Act 34 of 1995), as amended, including
for the purposes of its validity.'),
('2', 22, 'For the purposes of subitem (1), the date “6 December 1993”, where it appears in
the provisions of the previous Constitution under the heading “National Unity and
Reconciliation”, must be read as “11 May 1994”.'),

('1', 23, 'National legislation envisaged in sections 9(4), 32(2) and 33(3) of the new
Constitution must be enacted within three years of the date on which the new
Constitution took effect.'),
('2', 23, 'Until the legislation envisaged in sections 32(2) and 33(3) of the new Constitution is
enacted—'),
('2a', 23, 'section 32 (1) must be regarded to read as follows:
“(1) Every person has the right of access to all information held by the state or
any of its organs in any sphere of government in so far as that information is
required for the exercise or protection of any of their rights.”; and'),
('2b', 23, 'section 33(1) and (2) must be regarded to read as follows:
“Every person has the right to—
(a) lawful administrative action where any of their rights or interests is
affected or threatened;
(b) procedurally fair administrative action where any of their rights or
legitimate expectations is affected or threatened;
(c) be furnished with reasons in writing for administrative action which
affects any of their rights or interests unless the reasons for that action
have been made public; and
(d) administrative action which is justifiable in relation to the reasons given
for it where any of their rights is affected or threatened.”.'),
('3', 23, 'Sections 32(2) and 33(3) of the new Constitution lapse if the legislation envisaged
in those sections, respectively, is not enacted within three years of the date the new
Constitution took effect.'),

('1', 24, 'Sections 82(4)(b), 215, 218(1), 219(1), 224 to 228, 236(1), (2), (3), (6), (7)(b) and
(8), 237(1) and (2)(a) and 239(4) and (5) of the previous Constitution continue in
force as if the previous Constitution had not been repealed, subject to—'),
('1a', 24, 'the amendments to those sections as set out in Annexure D;'),
('1b', 24, 'any further amendment or any repeal of those sections by an Act of Parliament
passed in terms of section 75 of the new Constitution; and'),
('1c', 24, 'consistency with the new Constitution.'),
('2', 24, 'The Public Service Commission and the provincial service commissions referred to in
Chapter 13 of the previous Constitution continue to function in terms of that Chapter
and the legislation applicable to it as if that Chapter had not been repealed, until
the Commission and the provincial service commissions are abolished by an Act of
Parliament passed in terms of section 75 of the new Constitution.'),
('3', 24, 'The repeal of the previous Constitution does not affect any proclamation issued
under section 237(3) of the previous Constitution, and any such proclamation
continues in force, subject to—'),
('3a', 24, 'any amendment or repeal; and'),
('3b', 24, 'consistency with the new Constitution.'),

('1', 25, 'Anyone who, when the new Constitution took effect, was serving a sentence in the
Republic of more than 12 months’ imprisonment without the option of a fine, is not
eligible to be a member of the National Assembly or a provincial legislature.'),
('2', 25, 'The disqualification of a person in terms of subitem (1)—'),
('2a', 25, 'lapses if the conviction is set aside on appeal, or the sentence is reduced on
appeal to a sentence that does not disqualify that person; and'),
('2b', 25, 'ends five years after the sentence has been completed.'),

('1', 26, 'Notwithstanding the provisions of sections 151, 155, 156 and 157 of the new
Constitution—'),
('1a', 26, 'the provisions of the Local Government Transition Act, 1993 (Act 209 of 1993),
as may be amended from time to time by national legislation consistent with
the new Constitution, remain in force in respect of a Municipal Council until a
Municipal Council replacing that Council has been declared elected as a result
of the first general election of Municipal Councils after the commencement of
the new Constitution; and'),
('1b', 26, 'a traditional leader of a community observing a system of indigenous law and
residing on land within the area of a transitional local council, transitional
rural council or transitional representative council, referred to in the Local
Government Transition Act, 1993, and who has been identified as set out in
section 182 of the previous Constitution, is ex officio entitled to be a member
of that council until a Municipal Council replacing that council has been
declared elected as a result of the first general election of Municipal Councils
after the commencement of the new Constitution.'),
('2', 26, 'Section 245(4) of the previous Constitution continues in force until the application
of that section lapses. Section 16(5) and (6) of the Local Government Transition Act,
1993, may not be repealed before 30 April 2000.'),

('1', 28, 'On the production of a certificate by a competent authority that immovable
property owned by the state is vested in a particular government in terms of section
239 of the previous Constitution, a registrar of deeds must make such entries or
endorsements in or on any relevant register, title deed or other document to register
that immovable property in the name of that government.'),
('2', 28, 'No duty, fee or other charge is payable in respect of a registration in terms of
subitem (1).');
GO

INSERT INTO [ScheduleSchema].ScheduleSix_Clauses (ClauseID, SectionID, SubsectionID, ClauseText)
VALUES
('i', 3, '2a', 'Parliament under the new Constitution, if the administration of that
legislation has been allocated or assigned in terms of the previous
Constitution or this Schedule to the national executive; or'),
('ii', 3, '2a', 'the provincial legislature of a province, if the administration of that
legislation has been allocated or assigned in terms of the previous
Constitution or this Schedule to a provincial executive; or'),

('i', 3, '2b', 'the President under the new Constitution, if the administration of that
legislation has been allocated or assigned in terms of the previous
Constitution or this Schedule to the national executive; or'),
('ii', 3, '2b', 'the Premier of a province under the new Constitution, if the
administration of that legislation has been allocated or assigned in terms
of the previous Constitution or this Schedule to a provincial executive.'),

('i', 16, '7a', 'the President of the Constitutional Court, becomes the Chief Justice as
contemplated in section 167(1) of the new Constitution;'),
('ii', 16, '7a', 'the Deputy President of the Constitutional Court, becomes the Deputy
Chief Justice as contemplated in section 167(1) of the new Constitution;'),
('iii', 16, '7a', 'the Chief Justice, becomes the President of the Supreme Court of Appeal
as contemplated in section 168(1) of the new Constitution; and'),
('iv', 16, '7a', 'the Deputy Chief Justice, becomes the Deputy President of the
Supreme Court of Appeal as contemplated in section 168(1) of the new
Constitution.'),

('i', 20, '5a', 'any amendment or repeal of that legislation; and'),
('ii', 20, '5a', 'consistency with the new Constitution.');
GO

/* /////////////// Schedule 7's contents /////////// */
INSERT INTO [ScheduleSchema].ScheduleSeven_RepealedLaws (ActNum, Title)
VALUES
('Act No. 200 of 1993', 'Constitution of the Republic of South Africa, 1993'),
('Act No. 2 of 1994', 'Constitution of the Republic of South Africa Amendment Act, 1994'),
('Act No. 3 of 1994', 'Constitution of the Republic of South Africa Second Amendment Act, 1994'),
('Act No. 13 of 1994', 'Constitution of the Republic of South Africa Third Amendment Act, 1994'),
('Act No. 14 of 1994', 'Constitution of the Republic of South Africa Fourth Amendment Act, 1994'),
('Act No. 24 of 1994', 'Constitution of the Republic of South Africa Sixth Amendment Act, 1994'),
('Act No. 29 of 1994', 'Constitution of the Republic of South Africa Fifth Amendment Act, 1994'),
('Act No. 20 of 1995', 'Constitution of the Republic of South Africa Amendment Act, 1995'),
('Act No. 44 of 1995', 'Constitution of the Republic of South Africa Second Amendment Act, 1995'),
('Act No. 7 of 1996', 'Constitution of the Republic of South Africa Amendment Act, 1996'),
('Act No. 26 of 1996', 'Constitution of the Republic of South Africa Third Amendment Act, 1996');
GO

/* Annexures */

INSERT INTO [ScheduleSchema].Annexures (AnnexureID, AnnexureTitle)
VALUES
('A', 'Amendments to Schedule 2 to the previous Constitution'),
('B', 'Government of National Unity: National Sphere'),
('C', 'Government of National Unity: Provincial Sphere'),
('D', 'Public Administration and Security Services: Amendments to
Sections of the Previous Constitution');
GO

/* /////////////// Annexure A's contents /////////// */
INSERT INTO [ScheduleSchema].AnnexureContents (SectionID, AnnexureID, SectionTitle, SectionText)
VALUES
(1, 'A', 'The replacement of item 1 with the following item:', '“1. Parties registered in terms of national legislation and contesting an
election of the National Assembly, shall nominate candidates for such election
on lists of candidates prepared in accordance with this Schedule and national
legislation.”.'),
(2, 'A', 'The replacement of item 2 with the following item:', 
'“2. The seats in the National Assembly as determined in terms of section 46 of the
new Constitution, shall be filled as follows:
(a) One half of the seats from regional lists submitted by the respective
parties, with a fixed number of seats reserved for each region as
determined by the Commission for the next election of the Assembly,
taking into account available scientifically based data in respect of
voters, and representations by interested parties.
(b) The other half of the seats from national lists submitted by the respective
parties, or from regional lists where national lists were not submitted.”.'),
(3, 'A', 'The replacement of item 3 with the following item:',
'“3. The lists of candidates submitted by a party, shall in total contain the names
of not more than a number of candidates equal to the number of seats in the
National Assembly, and each such list shall denote such names in such fixed
order of preference as the party may determine.”.'),
(4, 'A', 'The amendment of item 5 by replacing the words preceding paragraph (a) with
the following words:',
'“5. The seats referred to in item 2(a) shall be allocated per region to the parties
contesting an election, as follows:”.'),
(5, 'A', 'The amendment of item 6—', NULL),
(6, 'A', 'The amendment of item 7(3) by replacing paragraph (b) with the following
paragraph:',  '“(b) An amended quota of votes per seat shall be determined by dividing the total
number of votes cast nationally, minus the number of votes cast nationally in
favour of the party referred to in paragraph (a), by the number of seats in the
Assembly, plus one, minus the number of seats finally allocated to the said
party in terms of paragraph (a).”'),
(7, 'A', 'The replacement of item 10 with the following item:', '“10. The number of seats in each provincial legislature shall be as determined in
terms of section 105 of the new Constitution.”.'),
(8, 'A', 'The replacement of item 11 with the following item:', '“11. Parties registered in terms of national legislation and contesting an election
of a provincial legislature, shall nominate candidates for election to such
provincial legislature on provincial lists prepared in accordance with this
Schedule and national legislation.”.'),
(9, 'A', 'The replacement of item 16 with the following item:', 
'“Designation of representatives
16. (1) After the counting of votes has been concluded, the number of
representatives of each party has been determined and the election result has
been declared in terms of section 190 of the new Constitution, the Commission
shall, within two days after such declaration, designate from each list of
candidates, published in terms of national legislation, the representatives of
each party in the legislature.
(2) Following the designation in terms of subitem (1), if a candidate’s name
appears on more than one list for the National Assembly or on lists for both the
National Assembly and a provincial legislature (if an election of the Assembly
and a provincial legislature is held at the same time), and such candidate is
due for designation as a representative in more than one case, the party which
submitted such lists shall, within two days after the said declaration, indicate
to the Commission from which list such candidate will be designated or in
which legislature the candidate will serve, as the case may be, in which event
the candidate’s name shall be deleted from the other lists.
(3) The Commission shall forthwith publish the list of names of representatives in
the legislature or legislatures.”..'),
(10, 'A', 'The amendment of item 18 by replacing paragraph (b) with the following
paragraph:', '“(b) a representative is appointed as a permanent delegate to the National Council
of Provinces;”.'),
(11, 'A', 'The replacement of item 19 with the following item:',
'“19. Lists of candidates of a party referred to in item 16 (1) may be supplemented
on one occasion only at any time during the first 12 months following the
date on which the designation of representatives in terms of item 16 has
been concluded, in order to fill casual vacancies: Provided that any such
supplementation shall be made at the end of the list.”.'),
(12, 'A', 'The replacement of item 23 with the following item:', 
'“Vacancies
23. (1) In the event of a vacancy in a legislature to which this Schedule applies,
the party which nominated the vacating member shall fill the vacancy by
nominating a person—
(a) whose name appears on the list of candidates from which the vacating
member was originally nominated; and
(b) who is the next qualified and available person on the list.
(2) A nomination to fill a vacancy shall be submitted to the Speaker in writing.
(3) If a party represented in a legislature dissolves or ceases to exist and the
members in question vacate their seats in consequence of item 23A(1), the
seats in question shall be allocated to the remaining parties mutatis mutandis
as if such seats were forfeited seats in terms of item 7 or 14, as the case may
be.”.'),
(13, 'A', 'The insertion of the following item after item 23:',
'“Additional ground for loss of membership of legislatures
23A. (1) A person loses membership of a legislature to which this Schedule applies
if that person ceases to be a member of the party which nominated that
person as a member of the legislature.
(2) Despite subitem (1) any existing political party may at any time change its
name.
(3) An Act of Parliament may, within a reasonable period after the new
Constitution took effect, be passed in accordance with section 76(1) of the
new Constitution to amend this item and item 23 to provide for the manner
in which it will be possible for a member of a legislature who ceases to be a
member of the party which nominated that member, to retain membership of
such legislature.
(4) An Act of Parliament referred to in subitem (3) may also provide for—
(a) any existing party to merge with another party; or
(b) any party to subdivide into more than one party.”.'),
(14, 'A', 'The deletion of item 24.', ''),
(15, 'A', 'The amendment of item 25—', NULL),
(16, 'A', 'The deletion of item 26.', '');
GO

INSERT INTO [ScheduleSchema].AnnexureSubsections (SubsectionID, SectionID, AnnexureID, SectionText)
VALUES
('0a', 5, 'A', 'by replacing the words preceding paragraph (a) with the following words:
“6. The seats referred to in item 2(b) shall be allocated to the parties
contesting an election, as follows:”; and'),
('0b', 5, 'A', 'by replacing paragraph (a) with the following paragraph:
“(a) A quota of votes per seat shall be determined by dividing the total
number of votes cast nationally by the number of seats in the National
Assembly, plus one, and the result plus one, disregarding fractions, shall
be the quota of votes per seat.”.'),

('0a', 15, 'A', 'by replacing the definition of “Commission” with the following definition:
“‘Commission’ means the Electoral Commission referred to in
section 190 of the new Constitution;”; and'),
('0b', 15, 'A', 'by inserting the following definition after the definition of “national list”:
“‘new Constitution’ means the Constitution of the Republic of South Africa,
1996;”.');
GO

/* /////////////// Annexure B's contents /////////// */
INSERT INTO [ScheduleSchema].AnnexureContents (SectionID, AnnexureID, SectionTitle, SectionText)
VALUES
(1, 'B', 'Section 84 of the new Constitution is deemed to contain the following
additional subsection:',
'“(3) The President must consult the Executive Deputy Presidents—
(a) in the development and execution of the policies of the national
government;
(b) in all matters relating to the management of the Cabinet and the
performance of Cabinet business;
(c) in the assignment of functions to the Executive Deputy Presidents;
(d) before making any appointment under the Constitution or any
legislation, including the appointment of ambassadors or other
diplomatic representatives;
(e) before appointing commissions of inquiry;
(f) before calling a referendum; and
(g) before pardoning or reprieving offenders.”.'),
(2, 'B', 'Section 89 of the new Constitution is deemed to contain the following
additional subsection:',
'“(3) Subsections (1) and (2) apply also to an Executive Deputy President.”.'),
(3, 'B', 'Paragraph (a) of section 90(1) of the new Constitution is deemed to read as
follows:',
'“(a) an Executive Deputy President designated by the President;”.'),
(4, 'B', 'Section 91 of the new Constitution is deemed to read as follows:',
'“Cabinet
91. (1) The Cabinet consists of the President, the Executive Deputy Presidents
and—
(a) not more than 27 Ministers who are members of the National Assembly
and appointed in terms of subsections (8) to (12); and
(b) not more than one Minister who is not a member of the 175 National
Assembly and appointed in terms of subsection (13), provided the
President, acting in consultation with the Executive Deputy Presidents
and the leaders of the participating parties, deems the appointment of
such a Minister expedient.
(2) Each party holding at least 80 seats in the National Assembly is entitled to
designate an Executive Deputy President from among the members of the
Assembly.
(3) If no party or only one party holds 80 or more seats in the Assembly, the party
holding the largest number of seats and the party holding the second largest
number of seats are each entitled to designate one Executive Deputy President
from among the members of the Assembly.
(4) On being designated, an Executive Deputy President may elect to remain or
cease to be a member of the Assembly.
(5) An Executive Deputy President may exercise the powers and must perform the
functions vested in the office of Executive Deputy President by the Constitution
or assigned to that office by the President.
(6) An Executive Deputy President holds office—
(a) until 30 April 1999 unless replaced or recalled by the party entitled to
make the designation in terms of subsections (2) and (3); or
(b) until the person elected President after any election of the National
Assembly held before 30 April 1999, assumes office.
(7) A vacancy in the office of an Executive Deputy President may be filled by the
party which designated that Deputy President.
(8) A party holding at least 20 seats in the National Assembly and which has
decided to participate in the government of national unity, is entitled to be
allocated one or more of the Cabinet portfolios in respect of which Ministers
referred to in subsection (1)(a) are to be appointed, in proportion to the
number of seats held by it in the National Assembly relative to the number of
seats held by the other participating parties.
(9) Cabinet portfolios must be allocated to the respective participating parties in
accordance with the following formula:
(a) A quota of seats per portfolio must be determined by dividing the
total number of seats in the National Assembly held jointly by the
participating parties by the number of portfolios in respect of which
Ministers referred to in subsection (1)(a) are to be appointed, plus one.
(b) The result, disregarding third and subsequent decimals, if any, is the
quota of seats per portfolio.
(c) The number of portfolios to be allocated to a participating party is
determined by dividing the total number of seats held by that party in
the National Assembly by the quota referred to in paragraph (b).
(d) The result, subject to paragraph (e), indicates the number of portfolios to
be allocated to that party.
(e) Where the application of the above formula yields a surplus not absorbed
by the number of portfolios allocated to a party, the surplus competes
with other similar surpluses accruing to another party or parties, and any
portfolio or portfolios which remain unallocated must be allocated to the
party or parties concerned in sequence of the highest surplus.
(10) The President after consultation with the Executive Deputy Presidents and the
leaders of the participating parties must—
(a) determine the specific portfolios to be allocated to the respective
participating parties in accordance with the number of portfolios
allocated to them in terms of subsection (9);
(b) appoint in respect of each such portfolio a member of the National
Assembly who is a member of the party to which that portfolio was
allocated under paragraph (a), as the Minister responsible for that
portfolio;
(c) if it becomes necessary for the purposes of the Constitution or in the
interest of good government, vary any determination under paragraph
(a), subject to subsection (9);
(d) terminate any appointment under paragraph (b)—
(i) if the President is requested to do so by the leader of the party of which
the Minister in question is a member; or
(ii) if it becomes necessary for the purposes of the Constitution or in the
interest of good government; or
(e) fill, when necessary, subject to paragraph (b), a vacancy in the office of
Minister.
(11) Subsection (10) must be implemented in the spirit embodied in the concept of
a government of national unity, and the President and the other functionaries
concerned must in the implementation of that subsection seek to achieve
consensus at all times: Provided that if consensus cannot be achieved on—
(a) the exercise of a power referred to in paragraph (a), (c) or (d)(ii) of that
subsection, the President’s decision prevails;
(b) the exercise of a power referred to in paragraph (b), (d)(i) or (e) of that
subsection affecting a person who is not a member of the President’s
party, the decision of the leader of the party of which that person is a
member prevails; and
(c) the exercise of a power referred to in paragraph (b) or (e) of that
subsection affecting a person who is a member of the President’s party,
the President’s decision prevails.
(12) If any determination of portfolio allocations is varied under subsection (10)
(c), the affected Ministers must vacate their portfolios but are eligible, where
applicable, for reappointment to other portfolios allocated to their respective
parties in terms of the varied determination.
(13) The President—
(a) in consultation with the Executive Deputy Presidents and the leaders of
the participating parties, must—
(i) determine a specific portfolio for a Minister referred to in subsection (1)
(b) should it become necessary pursuant to a decision of the President
under that subsection;
(ii) appoint in respect of that portfolio a person who is not a member of the
National Assembly, as the Minister responsible for that portfolio; and
(iii) fill, if necessary, a vacancy in respect of that portfolio; or
(b) after consultation with the Executive Deputy Presidents and the
leaders of the participating parties, must terminate any appointment
under paragraph (a) if it becomes necessary for the purposes of the
Constitution or in the interest of good government.
(14) Meetings of the Cabinet must be presided over by the President, or, if the
President so instructs, by an Executive Deputy President: Provided that the
Executive Deputy Presidents preside over meetings of the Cabinet in turn
unless the exigencies of government and the spirit embodied in the concept of
a government of national unity otherwise demand.
(15) The Cabinet must function in a manner which gives consideration to the
consensus-seeking spirit embodied in the concept of a government of national
unity as well as the need for effective government.”.'),
(5, 'B', 'Section 93 of the new Constitution is deemed to read as follows:',
'“Appointment of Deputy Ministers
93. (1) The President may, after consultation with the Executive Deputy
Presidents and the leaders of the parties participating in the Cabinet, establish
deputy ministerial posts.
(2) A party is entitled to be allocated one or more of the deputy ministerial posts
in the same proportion and according to the same formula that portfolios in
the Cabinet are allocated.
(3) The provisions of section 91(10) to (12) apply, with the necessary changes, in
respect of Deputy Ministers, and in such application a reference in that section
to a Minister or a portfolio must be read as a reference to a Deputy Minister or
a deputy ministerial post, respectively.
(4) If a person is appointed as the Deputy Minister of any portfolio entrusted to a
Minister—
(a) that Deputy Minister must exercise and perform on behalf of the relevant
Minister any of the powers and functions assigned to that Minister
in terms of any legislation or otherwise which may, subject to the
directions of the President, be assigned to that Deputy Minister by that
Minister; and
(b) any reference in any legislation to that Minister must be construed
as including a reference to the Deputy Minister acting in terms of an
assignment under paragraph (a) by the Minister for whom that Deputy
Minister acts.
(5) Whenever a Deputy Minister is absent or for any reason unable to exercise or
perform any of the powers or functions of office, the President may appoint
any other Deputy Minister or any other person to act in the said Deputy
Minister’s stead, either generally or in the exercise or performance of any
specific power or function.”.'),
(6, 'B', 'Section 96 of the new Constitution is deemed to contain the following
additional subsections:',
'“(3) Ministers are accountable individually to the President and to the National
Assembly for the administration of their portfolios, and all members of the
Cabinet are correspondingly accountable collectively for the performance of
the functions of the national government and for its policies.
Annexure B
165
(4) Ministers must administer their portfolios in accordance with the policy
determined by the Cabinet.
(5) If a Minister fails to administer the portfolio in accordance with the policy of
the Cabinet, the President may require the Minister concerned to bring the
administration of the portfolio into conformity with that policy.
(6) If the Minister concerned fails to comply with a requirement of the President
under subsection (5), the President may remove the Minister from office—
(a) if it is a Minister referred to in section 91(1)(a), after consultation with
the Minister and, if the Minister is not a member of the President’s party
or is not the leader of a participating party, also after consultation with
the leader of that Minister’s party; or
(b) if it is a Minister referred to in section 91(1)(b), after consultation with
the Executive Deputy Presidents and the leaders of the participating
parties.”.');
GO

/* /////////////// Annexure C's contents /////////// */
INSERT INTO [ScheduleSchema].AnnexureContents (SectionID, AnnexureID, SectionTitle, SectionText)
VALUES
(1, 'C', 'Section 132 of the new Constitution is deemed to read as follows:',
'“Executive Councils
132. (1) The Executive Council of a province consists of the Premier and not more
than 10 members appointed by the Premier in accordance with this section.
(2) A party holding at least 10 per cent of the seats in a provincial legislature
and which has decided to participate in the government of national unity,
is entitled to be allocated one or more of the Executive Council portfolios in
proportion to the number of seats held by it in the legislature relative to the
number of seats held by the other participating parties.
(3) Executive Council portfolios must be allocated to the respective participating
parties according to the same formula set out in section 91(9), and in applying
that formula a reference in that section to—
(a) the Cabinet, must be read as a reference to an Executive Council;
(b) a Minister, must be read as a reference to a member of an
Executive Council; and
(c) the National Assembly, must be read as a reference to the provincial
legislature.
(4) The Premier of a province after consultation with the leaders of the
participating parties must—
(a) determine the specific portfolios to be allocated to the respective
participating parties in accordance with the number of portfolios
allocated to them in terms of subsection (3);
(b) appoint in respect of each such portfolio a member of the provincial
legislature who is a member of the party to which that portfolio was
allocated under paragraph (a), as the member of the Executive Council
responsible for that portfolio;
(c) if it becomes necessary for the purposes of the Constitution or in the
interest of good government, vary any determination under paragraph
(a), subject to subsection (3);
(d) terminate any appointment under paragraph (b)—
(i) if the Premier is requested to do so by the leader of the party of which
the Executive Council member in question is a member; or
(ii) if it becomes necessary for the purposes of the Constitution or in the
interest of good government; or
(e) fill, when necessary, subject to paragraph (b), a vacancy in the office of a
member of the Executive Council.
(5) Subsection (4) must be implemented in the spirit embodied in the concept of
a government of national unity, and the Premier and the other functionaries
concerned must in the implementation of that subsection seek to achieve
consensus at all times: Provided that if consensus cannot be achieved on—
(a) the exercise of a power referred to in paragraph (a), (c) or ( d)(ii) of that
subsection, the Premier’s decision prevails;
(b) the exercise of a power referred to in paragraph (b), (d)(i) or (e) of that
subsection affecting a person who is not a member of the Premier’s
party, the decision of the leader of the party of which such person is a
member prevails; and
(c) the exercise of a power referred to in paragraph (b) or (e) of that
subsection affecting a person who is a member of the Premier’s party,
the Premier’s decision prevails.
(6) If any determination of portfolio allocations is varied under subsection (4)
(c), the affected members must vacate their portfolios but are eligible, where
applicable, for reappointment to other portfolios allocated to their respective
parties in terms of the varied determination.
(7) Meetings of an Executive Council must be presided over by the Premier of the
province.
(8) An Executive Council must function in a manner which gives consideration
to the consensus-seeking spirit embodied in the concept of a government of
national unity, as well as the need f or effective government.”.'),
(2, 'C', 'Section 136 of the new Constitution is deemed to contain the following
additional subsections:',
'“(3) Members of Executive Councils are accountable individually to the Premier and
to the provincial legislature for the administration of their portfolios, and all
members of the Executive Council are correspondingly accountable collectively
for the performance of the functions of the provincial government and for its
policies.
(4) Members of Executive Councils must administer their portfolios in accordance
with the policy determined by the Council.
(5) If a member of an Executive Council fails to administer the portfolio in
accordance with the policy of the Council, the Premier may require the
member concerned to bring the administration of the portfolio into conformity
with that policy.
(6) If the member concerned fails to comply with a requirement of the Premier
under subsection (5), the Premier may remove the member from office
after consultation with the member, and if the member is not a member
of the Premier’s party or is not the leader of a participating party, also after
consultation with the leader of that member’s party.”.');
GO

/* /////////////// Annexure D's contents /////////// */
INSERT INTO [ScheduleSchema].AnnexureContents (SectionID, AnnexureID, SectionTitle, SectionText)
VALUES
(1, 'D', 'The amendment of section 218 of the previous Constitution—', NULL),
(2, 'D', 'The amendment of section 219 of the previous Constitution by replacing in
subsection (1) the words preceding paragraph (a) with the following words:',  '“(1) Subject to section 218(1), a Provincial Commissioner shall be responsible
for—”.'),
(3, 'D', 'The amendment of section 224 of the previous Constitution by replacing the
proviso to subsection (2) with the following proviso:',
'“Provided that this subsection shall also apply to members of any armed force
which submitted its personnel list after the commencement of the Constitution
of the Republic of South Africa, 993 (Act 200 of 1993), but before the adoption of
the new constitutional text as envisaged in section 73 of that Constitution, if the
political organisation under whose authority and control it stands or with which it
is associated and whose objectives it promotes did participate in the Transitional
Executive Council or did take part in the first election of the National Assembly and
the provincial legislatures under the said Constitution.”.'),
(4, 'D', 'The amendment of section 227 of the previous Constitution by replacing
subsection (2) with the following subsection:',
'“(2) The National Defence Force shall exercise its powers and perform its functions
solely in the national interest in terms of Chapter 11 of the Constitution of the
Republic of South Africa, 1996.”.'),
(5, 'D', 'The amendment of section 236 of the previous Constitution—', NULL),
(6, 'D', 'The amendment of section 237 of the previous Constitution—', NULL),
(7, 'D', 'The amendment of section 239 of the previous Constitution by replacing
subsection (4) with the following subsection:', '“(4) Subject to and in accordance with any applicable law, the assets, rights, duties
and liabilities of all forces referred to in section 224(2) shall devolve upon the
National Defence Force in accordance with the directions of the Minister of
Defence.”.');
GO

INSERT INTO [ScheduleSchema].AnnexureSubsections (SubsectionID, SectionID, AnnexureID, SectionText)
VALUES
('0a', 1, 'D', 'by replacing in subsection (1) the words preceding paragraph (a) with the
following words: “(1) Subject to the directions of the Minister of Safety and Security, the
National Commissioner shall be responsible for—”;'),
('0b', 1, 'D', 'by replacing paragraph (b) of subsection (1) with the following paragraph:
“(b) the appointment of provincial commissioners;”;'),
('0c', 1, 'D', 'by replacing paragraph (d) of subsection (1) with the following paragraph:
“(d) the investigation and prevention of organised crime or crime which
requires national investigation and prevention or specialised skills;”; and'),
('0d', 1, 'D', 'by replacing paragraph (k) of subsection (1) with the following paragraph:
“(k) the establishment and maintenance of a national public order policing
unit to be deployed in support of and at the request of the Provincial
Commissioner;”.'),

('0a', 5, 'D', 'by replacing subsection (1) with the following subsection—
“(1) A public service, department of state, administration or security service
which immediately before the commencement of the Constitution of the
Republic of South Africa, 1996 (hereinafter referred to as “the new Constitution”),
performed governmental functions, continues to function in terms of
the legislation applicable to it until it is abolished or incorporated or integrated
into any appropriate institution or is rationalised or consolidated with any
other institution.”;'),
('0b', 5, 'D', 'by replacing subsection (6) with the following subsection:
“(6) (a) The President may appoint a commission to review the conclusion
or amendment of a contract, the appointment or promotion, or the
award of a term or condition of service or other benefit, which occurred
between 27 April 1993 and 30 September 1994 in respect of any person
referred to in subsection (2) or any class of such persons.
(b) The commission may reverse or alter a contract, appointment, promotion or
award if not proper or justifiable in the circumstances of the case.”; and
(c) by replacing “this Constitution”, wherever this occurs in section 236, with
“the new Constitution”.'),

('0a', 6, 'D', 'by replacing paragraph (a) of subsection (1) with the following paragraph:
“(a) The rationalisation of all institutions referred to in section 236(1),
excluding military forces referred to in section 224(2), shall after the
commencement of the Constitution of the Republic of South Africa, 1996,
continue, with a view to establishing—
(i) an effective administration in the national sphere of government to deal
with matters within the jurisdiction of the national sphere; and
(ii) an effective administration for each province to deal with matters within
the jurisdiction of each provincial government.”; and'),
('0b', 6, 'D', 'by replacing subparagraph (i) of subsection (2)(a) with the following
subparagraph:
“(i) institutions referred to in section 236(1), excluding military forces,
shall rest with the national government, which shall exercise such
responsibility in co-operation with the provincial governments;”.');
GO

/* END OF SCHEDULESCHEMA */


/*
	//////////////////////
	END OF SQL SCRIPT
	//////////////////////
*/