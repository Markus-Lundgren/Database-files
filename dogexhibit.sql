create table Owner (
    Id int auto_increment primary key,
    Name varchar(64)
);

create table Dog (
    Id int auto_increment primary key,
    Name varchar(32),
    Breed int,
    OwnerId int
);

create table Breed(
    Id int auto_increment primary key,
    Name varchar(64)
);

create table DogToExhibit(
    ExhibitId int,
    DogId int,
    Score int
);

create table Exhibit(
    Id int auto_increment primary key,
    Name varchar(32),
    Date date
);

alter table Dog add column ExhibitId int;

insert into Owner(Name) values('Markus'),
                        ('Moa'),
                        ('Erik'),
                        ('Brain');
insert into Breed(Name) values('Basset'),
('Boxer'),
('Dobermann'),
('Greyhound'),
('Husky'),
('Mops'),
('Papillon'),
('Pointer'),
('Setter'),
('Terrier');

select * from Owner;

select * from Dog;

select * from DogToExhibit;

select * from Exhibit;

select Dog.Name, DogToExhibit.Score
from DogToExhibit
    join Dog on DogToExhibit.DogId = Dog.Id
where DogToExhibit.ExhibitId = 1
order by DogToExhibit.Score desc;

-- Visa topp 10 hundars score över alla tävlingar de varit med på
select Dog.Name, Breed.Name, Sum(DogToExhibit.Score) as Score
from DogToExhibit
    join Dog on DogToExhibit.DogId = Dog.Id
    join Breed on Dog.Breed = Breed.Id
group by Dog.Name
order by Score desc
limit 10;

select * from Dog where Breed = 3;

select Dog.Name, DogToExhibit.Score, DogToExhibit.ExhibitId from DogToExhibit
    join Dog on DogToExhibit.DogId = Dog.Id
    where Dog.Name = 'Siri';

select Name from Owner where Id = 2;
select * from Dog where OwnerId = 2;

select Dog.Name, Breed.Name, sum(DogToExhibit.Score), Owner.Name from Dog
    join Breed on Dog.Breed = Breed.Id
    join Owner on Dog.OwnerId = Owner.Id
    join DogToExhibit on Dog.Id = DogToExhibit.DogId
    where Dog.Breed = 1
    group by Dog.Id
    order by sum(DogToExhibit.Score) desc;

select Dog.Name, Breed.Name, DogToExhibit.Score, Exhibit.Name from Dog
    join Breed on Dog.Breed = Breed.Id
    join Owner on Dog.OwnerId = Owner.Id
    join DogToExhibit on Dog.Id = DogToExhibit.DogId
    join Exhibit on DogToExhibit.ExhibitId = Exhibit.Id
    #where DogToExhibit.ExhibitId = 1
order by DogToExhibit.Score desc;

