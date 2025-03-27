create database VirtualArtGallery;
use VirtualArtGallery;

-- Artists Table --
create table Artists (
       ArtistID INT PRIMARY KEY,
       Name VARCHAR(255) NOT NULL,
       Biography TEXT,
       Nationality VARCHAR(100)
);

-- Categories Table --
create table Categories (
       CategoryID INT PRIMARY KEY,
       Name VARCHAR(100) NOT NULL
);

-- Artworks Table --
create table Artworks (
       ArtworkID INT PRIMARY KEY,
       Title VARCHAR(255) NOT NULL,
       ArtistID INT,
       CategoryID INT,
       Year INT,
       Description TEXT,
       ImageURL VARCHAR(255),
       FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
       FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID)
);

-- Exhibitions Table --
create table Exhibitions (
       ExhibitionID INT PRIMARY KEY,
       Title VARCHAR(255) NOT NULL,
       StartDate DATE,
       EndDate DATE,
       Description TEXT
);

-- ExhibitionArtworks --
create table ExhibitionArtworks (
       ExhibitionID INT,
       ArtworkID INT,
       PRIMARY KEY (ExhibitionID, ArtworkID),         -- composite primary key
       FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
       FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID)
);


-- Inserting Data into Artist Table --
insert into Artists (ArtistID, Name, Biography, Nationality) values
            (1, "Pablo Picasso","Renowned Spanish painter and sculptor","Spanish"),
            (2, "Vincent van Gogh", "Dutch post-impressionist painter", "Dutch"),
            (3, "Leonardo da Vinci", "Italian polymath of the Renaissance", "Italian");
            
-- Inserting Data into Categories Table --
insert into Categories (CategoryID, Name) values
	    (1, "Painting"),
            (2, "Sculpture"),
            (3,"Photography");

-- Inserting Data into Artworks Table --
insert into Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) values
            (1, "Starry Night", 2, 1, 1889, "A famous painting by Vincent van Gogh", "starry_night.jpg"),
            (2, "Mona Lisa", 3, 1, 1503, "The iconic portrait by Leonardo da Vinci", "mona_lisa.jpg"), 
	    (3, "Guernica", 1, 1, 1937, "Pablo Picasso\'s powerful anti-war mural", "guernica.jpg");
            
-- Inserting Data into Exhibitions Table --
insert into Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) values
	    (1, "Modern Art Masterpieces", '2023-01-01', '2023-03-01', "A collection of modern art masterpieces"),
            (2, "Renaissance Art", '2023-04-01', '2023-06-01', "A showcase of Renaissance art treasures");
            
-- Inserting Data into ExhibitionArtworks Table --
insert into ExhibitionArtworks (ExhibitionID, ArtworkID) values
	    (1,1),
            (1,2),
            (1,3),
            (2,2);
           
           
-- Queries --

-- 1. Retrieve the names of all artists along with the number of artworks they have in the gallery, and list them in descending order of the number of artworks.

select a.Name as ArtistName, COUNT(aw.ArtworkID) as NumberOfArtworks from Artists a LEFT JOIN Artworks aw ON a.ArtistID = aw.ArtistID group by a.ArtistID, a.Name order by NumberOfArtworks desc;

-- 2. List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order them by the year in ascending order.

select aw.Title as TitleOfArtworks,aw.Year from Artworks aw JOIN Artists a ON aw.ArtistID = a.ArtistID where a.Nationality = "Spanish" or a.Nationality = "Dutch" order by aw.Year asc;

-- 3. Find the names of all artists who have artworks in the 'Painting' category, and the number of artworks they have in this category.

select a.Name, COUNT(aw.ArtworkID) as NumberOfArtworks from Artists a JOIN Artworks aw ON a.ArtistID = aw.ArtistID JOIN Categories c ON c.CategoryID = aw.CategoryID where c.Name = "Painting" group by a.ArtistID, a.Name;
 
-- 4. List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their artists and categories.

select a.Name as ArtistName, c.Name as CategoryName, aw.Title as ArtworkName from Artworks aw JOIN ExhibitionArtworks ea ON aw.ArtworkID = ea.ArtworkID JOIN Exhibitions e ON e.ExhibitionID = ea.ExhibitionID JOIN Categories c ON c.CategoryID = aw.CategoryID JOIN Artists a ON a.ArtistID = aw.ArtistID where e.Title = "Modern Art Masterpieces";

-- 5. Find the artists who have more than two artworks in the gallery.

select a.Name as ArtistName, COUNT(aw.ArtworkID) as NumberOfArtworks  from Artists a JOIN Artworks aw ON a.ArtistID = aw.ArtistID group by a.ArtistID, a.Name HAVING COUNT(aw.ArtworkID) > 2;

-- 6. Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and 'Renaissance Art' exhibitions

select aw.Title from Artworks aw JOIN ExhibitionArtworks ea1 ON aw.ArtworkID = ea1.ArtworkID  JOIN Exhibitions e1 ON e1.ExhibitionID = ea1.ExhibitionID JOIN ExhibitionArtworks ea2 ON aw.ArtworkID = ea2.ArtworkID  JOIN Exhibitions e2 ON e2.ExhibitionID = ea2.ExhibitionID where e1.Title = "Modern Art Masterpieces" and e2.Title = "Renaissance Art";

-- 7. Find the total number of artworks in each category

select c.Name, COUNT(aw.ArtworkID) as TotalNoOfArtworks from Categories c LEFT JOIN Artworks aw ON c.CategoryID = aw.CategoryID group by c.CategoryID, c.Name;

-- 8. List artists who have more than 3 artworks in the gallery

select a.Name as ArtistName, COUNT(aw.ArtworkID) as NumberOfArtworks  from Artists a JOIN Artworks aw ON a.ArtistID = aw.ArtistID group by a.ArtistID, a.Name HAVING COUNT(aw.ArtworkID) > 3;

-- 9. Find the artworks created by artists from a specific nationality (e.g., Spanish)

select a.Name as ArtistName, aw.Title as ArtworkTitle from Artists a JOIN Artworks aw ON a.ArtistID = aw.ArtistID where a.Nationality = "Spanish";

-- 10. List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci

select a.Name, a1.Name, e.Title, e.StartDate, e.EndDate,e.Description from Exhibitions e JOIN ExhibitionArtworks ea ON e.ExhibitionID = ea.ExhibitionID JOIN Artworks aw ON ea.ArtworkID = aw.ArtworkID JOIN Artists a ON aw.ArtistID = a.ArtistID JOIN ExhibitionArtworks ea1 ON e.ExhibitionID = ea1.ExhibitionID JOIN Artworks aw1 ON ea1.ArtworkID = aw1.ArtworkID JOIN Artists a1 ON aw1.ArtistID = a1.ArtistID where a.Name = "Vincent van Gogh" and a1.Name = "Leonardo da Vinci";

-- 11. Find all the artworks that have not been included in any exhibition

select aw.Title from Artworks aw LEFT JOIN ExhibitionArtworks ea ON aw.ArtworkID = ea.ArtworkID where ea.ExhibitionID is NULL;

-- 12. List artists who have created artworks in all available categories

select a.Name as ArtistName from Artists a JOIN Artworks aw ON a.ArtistID = aw.ArtistID JOIN Categories c ON aw.CategoryID = c.CategoryID group by a.ArtistID, a.Name HAVING count(DISTINCT aw.CategoryID) = (select count(*) from Categories);

-- 13. List the total number of artworks in each category

select c.Name, count(aw.ArtworkID) as TotalNumberOfArtworks from Categories c LEFT JOIN Artworks aw ON c.CategoryID = aw.CategoryID group by c.CategoryID, c.Name;

-- 14. Find the artists who have more than 2 artworks in the gallery

select a.Name as ArtistName, COUNT(aw.ArtworkID) as NumberOfArtworks  from Artists a JOIN Artworks aw ON a.ArtistID = aw.ArtistID group by a.ArtistID, a.Name HAVING COUNT(aw.ArtworkID) > 2;

-- 15. List the categories with the average year of artworks they contain, only for categories with more than 1 artwork

select c.Name as CategoryName, avg(aw.Year) as AverageYear from Categories c JOIN Artworks aw ON c.CategoryID = aw.categoryID group by c.CategoryID, c.Name Having count(aw.ArtworkID) > 1;

-- 16. Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition

select aw.Title as ArtworkName, aw.Year, aw.Description, aw.ImageURL  from Artworks aw JOIN ExhibitionArtworks ea ON aw.ArtworkID = ea.ArtworkID JOIN Exhibitions e ON e.ExhibitionID = ea.ExhibitionID where e.Title = "Modern Art Masterpieces";

-- 17. Find the categories where the average year of artworks is greater than the average year of all artworks

select c.Name, avg(aw.Year) as AverageYear from Categories c JOIN Artworks aw ON c.CategoryID = aw.CategoryID group by c.CategoryID, c.Name HAVING avg(aw.Year) > (select avg(Year) from Artworks);

-- 18. List the artworks that were not exhibited in any exhibition

select aw.Title from Artworks aw LEFT JOIN ExhibitionArtworks ea ON aw.ArtworkID = ea.ArtworkID where ea.ExhibitionID is NULL;

-- 19. Show artists who have artworks in the same category as "Mona Lisa"

select DISTINCT a.Name as ArtistName from Artists a JOIN Artworks aw ON a.ArtistID = aw.ArtistID where aw.CategoryID = (select CategoryID from Artworks where Title = "Mona Lisa");

-- 20. List the names of artists and the number of artworks they have in the gallery

select a.Name as ArtistName, count(aw.ArtworkID) as NumberOfArtworks from Artists a JOIN Artworks aw ON a.ArtistID = aw.ArtistID group by a.ArtistID, a.Name;
