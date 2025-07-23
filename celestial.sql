CREATE DATABASE universe;

CREATE TABLE galaxy(
galaxy_id SERIAL PRIMARY KEY,
name VARCHAR(20) UNIQUE NOT NULL,
identifier VARCHAR(10) UNIQUE,
galaxy_type VARCHAR(20) NOT NULL,
distance_ly INTEGER,
magnitude NUMERIC,
visible BOOLEAN
);

CREATE TABLE star(
star_id SERIAL PRIMARY KEY,
galaxy_id INTEGER,
name VARCHAR(20) UNIQUE NOT NULL,
star_type VARCHAR(20) NOT NULL,
magnitude NUMERIC NOT NULL,
visible BOOLEAN,
FOREIGN KEY (galaxy_id) REFERENCES galaxy(galaxy_id)
);

CREATE TABLE planet(
planet_id SERIAL PRIMARY KEY,
star_id INTEGER NOT NULL,
name VARCHAR(20) UNIQUE NOT NULL,
radius_km INTEGER NOT NULL,
orbit_years NUMERIC (7, 4),
FOREIGN KEY (star_id) REFERENCES star(star_id)
);

CREATE TABLE moon(
moon_id SERIAL PRIMARY KEY,
planet_id INTEGER NOT NULL,
name VARCHAR(20) UNIQUE NOT NULL,
spherical BOOLEAN NOT NULL,
radius_km INTEGER,
dimension_x_km INTEGER,
dimension_y_km INTEGER,
dimension_z_km INTEGER,
FOREIGN KEY (planet_id) REFERENCES planet(planet_id)
);

CREATE TABLE source(
source_id SERIAL PRIMARY KEY NOT NULL,
name VARCHAR UNIQUE,
publication TEXT,
source_url TEXT NOT NULL
);

CREATE TABLE source_galaxy(
source_id INT NOT NULL,
galaxy_id INT NOT NULL,
FOREIGN KEY (source_id) REFERENCES source(source_id),
FOREIGN KEY (galaxy_id) REFERENCES galaxy(galaxy_id)
);

CREATE TABLE source_star(
source_id INT NOT NULL,
star_id INT NOT NULL,
FOREIGN KEY (source_id) REFERENCES source(source_id),
FOREIGN KEY (star_id) REFERENCES star(star_id)
);

CREATE TABLE source_planet(
source_id INT NOT NULL,
planet_id INT NOT NULL,
FOREIGN KEY (source_id) REFERENCES source(source_id),
FOREIGN KEY (planet_id) REFERENCES planet(planet_id)
);

CREATE TABLE source_moon(
source_id INT NOT NULL,
moon_id INT NOT NULL,
FOREIGN KEY (source_id) REFERENCES source(source_id),
FOREIGN KEY (moon_id) REFERENCES moon(moon_id)
);

INSERT INTO galaxy(name, identifier, galaxy_type, distance_ly, magnitude, visible) VALUES
(‘Milky Way’, NULL, ‘Spiral’, 32616, NULL, TRUE),
(‘Andromeda’, ’M31’, ‘Spiral’, 2511404, 3.1, TRUE),
(‘Messier 87’, ‘M87’, ‘Elliptical’, 54000000, 9.6, FALSE),
(‘Maffei 1’, ‘Maffei 1’, ‘Elliptical’, 9784691, 13.47, FALSE),
(‘Black Eye’, ‘M64’, ‘Spiral’, 17000000, 9.8, FALSE),
(‘Triangulum’, ‘M33’, ‘Spiral’, 3000000, 5.7, TRUE)
;

INSERT INTO star(galaxy_id, name, star_type, magnitude, visible) VALUES
(1, ‘GJ1289’, ‘Red Dwarf’, 12.67, FALSE),
(1, ‘Gacrux’, ‘Red Giant’, 1.64, TRUE),
(1, ‘Proxima Centauri’, ‘Red Dwarf’, 11, FALSE),
(1, ‘Antares’, ‘Red Giant’, 1.1, TRUE),
(1, ‘Sol’, ‘Yellow Dwarf’, -26.74, TRUE),
(1, ‘Tau Ceti’, ‘Yellow Dwarf’, 3.5, TRUE)
;

INSERT INTO planet(star_id, name, radius_km, orbit_years) VALUES
(5, ‘Mercury’, 2440, 0.241),
(5, ‘Venus’, 6052, .616),  
(5, ‘Earth’, 6379, 1),
(5, ‘Mars’, 3396, 1.88),
(5, ‘Jupiter’, 71492, 11.87),
(5, ‘Saturn’, 60259, 29.47),
(5, ‘Uranus’, 25559, 83.94),
(5, ‘Neptune’, 24764, 164.37),
(3, ‘Proxima Centauri b’, 6571, 0.0307),
(1, ‘GJ 1289 b’, 14891, 0.306),
(6, ‘Tau Ceti g’, 7528, 0.0548),
(6, ‘Tau Ceti e’, 11548, 0.446)
;

INSERT INTO moon(planet_id, name, spherical, radius_km, dimension_x_km, dimension_y_km, dimension_z_km) VALUES
(3, ‘Moon’, TRUE, 1738, NULL, NULL, NULL),
(4, ‘Phobos’, FALSE, NULL, 27, 22, 18),
(4, ‘Deimos’, FALSE, NULL, 15, 12, 11),
(5, ‘Ganymede’, TRUE, 2633, NULL, NULL, NULL),
(5, ‘Callisto’, TRUE, 2407, NULL, NULL, NULL),
(5, ‘Io’, TRUE, 1819, NULL, NULL, NULL),
(5, ‘Europa’, TRUE, 1560, NULL, NULL, NULL),
(6, ‘Enceladus’, TRUE, 256, NULL, NULL, NULL),
(6, ‘Titan’, TRUE, 2575, NULL, NULL, NULL),
(6, ‘Dione’, TRUE, 566, NULL, NULL, NULL),
(6, ‘Rhea’, TRUE, 765, NULL, NULL, NULL),
(6, ‘Tethys’, FALSE, NULL, 669, 657, 654),
(6, ‘Mimas’, FALSE, NULL, 129, 122, 119),
(7, ‘Miranda’, TRUE, 243, NULL, NULL, NULL),
(7, ‘Umbriel’, TRUE, 593, NULL, NULL, NULL),
(7, ‘Titania’, TRUE, 795, NULL, NULL, NULL),
(8, ‘Triton’, TRUE, 1350, NULL, NULL, NULL),
(5, ‘Pasiphae’, TRUE, 25, NULL, NULL, NULL),
(8, ‘Proteus’, TRUE, 200, NULL, NULL, NULL),
(8, ‘Galatea’, TRUE, 75, NULL, NULL, NULL),
(5, ‘Leda’, TRUE, 8, NULL, NULL, NULL),
(5, ‘Himalia’, TRUE, 93, NULL, NULL, NULL),
(5, ‘Lysithia’, TRUE, 18, NULL, NULL, NULL),
(5, ‘Elara’, TRUE, 38, NULL, NULL, NULL),
(5, ‘Ananke’, TRUE, 15, NULL, NULL, NULL),
(5, ‘Carme’, TRUE, 20, NULL, NULL, NULL),
(5, ‘Sinope’, TRUE, 18, NULL, NULL, NULL),
(6, ‘Prometheus’, FALSE, NULL, 140, 100, 80),
(6, ‘Pandora’, FALSE, NULL, 110, 90, 80),
(6, ‘Epimetheus’, FALSE, NULL, 140, 120, 100),
(6, ‘Janus’, FALSE, NULL, 220, 200, 160),
(6, ‘Calypso’, FALSE, NULL, 34, 22, 22),
(6, ‘Helene’, FALSE, NULL, 36, 32, 30),
(6, ‘Hyperion’, FALSE, NULL, 410, 260, 220),
(6, ‘Iapetus’, TRUE, 730, NULL, NULL, NULL),
(6, ‘Phoebe’, TRUE, 110, NULL, NULL, NULL),
(7, ‘Cordelia’, TRUE, 13, NULL, NULL, NULL),
(7, ‘Ophelia’, TRUE, 15, NULL, NULL, NULL),
(7, ‘Bianca’, TRUE, 21, NULL, NULL, NULL),
(7, ‘Juliet’, TRUE, 31, NULL, NULL, NULL),
(7, ‘Desdemona’, TRUE, 27, NULL, NULL, NULL),
(7, ‘Rosalind’, TRUE, 42, NULL, NULL, NULL),
(7, ‘Portia’, TRUE, 54, NULL, NULL, NULL),
(7, ‘Cressida’, TRUE, 27, NULL, NULL, NULL),
(7, ‘Belinda’, TRUE, 33, NULL, NULL, NULL),
(7, ‘Puck’, TRUE, 77, NULL, NULL, NULL),
(7, ‘Ariel’, TRUE, 579, NULL, NULL, NULL),
(7, ‘Oberon’, TRUE, 762, NULL, NULL, NULL),
(8, ‘Naiad’, TRUE, 27, NULL, NULL, NULL),
(8, ‘Thalassa’, TRUE, 40, NULL, NULL, NULL),
(8, ‘Despina’, TRUE, 90, NULL, NULL, NULL),
(8, ‘Larissa’, TRUE, 95, NULL, NULL, NULL),
(8, ‘Nereid’, TRUE, 170, NULL, NULL, NULL)
);

INSERT INTO source(source_id, publication, source_url) VALUES
(1, 'Encyclopaedia Britannica', 'https://www.britannica.com/place/Milky-Way-Galaxy'), 
(2, 'The Astronomical Journal', 'https://iopscience.iop.org/article/10.1086/382905'),
(3, 'Encyclopaedia Britannica', 'https://www.britannica.com/place/Andromeda-Galaxy'),
(4, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/mission/hubble/science/explore-the-night-sky/hubble-messier-catalog/messier-31/'), 
(5, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/mission/hubble/science/explore-the-night-sky/hubble-messier-catalog/messier-87/'),
(6, 'National Aeronautics and Space Administration', 'https://www.britannica.com/place/Maffei-1'),
(7,'National Aeronautics and Space Administration', 'https://science.nasa.gov/mission/hubble/science/explore-the-night-sky/hubble-messier-catalog/messier-64/'),
(8, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/mission/hubble/science/explore-the-night-sky/hubble-messier-catalog/messier-33/'),
(9, 'Extra Solar Planets Encyclopaedia', 'https://exoplanet.eu/catalog/gj_1289_b--9383/'),
(10, 'Astronomy & Astrophysics', 'https://www.aanda.org/articles/aa/full_html/2024/08/aa50466-24/aa50466-24.html'),
(11, 'Encyclopaedia Britannica', 'https://www.britannica.com/topic/Gacrux'),
(12, 'Encyclopaedia Britannica', 'https://www.britannica.com/science/Proxima-Centauri'),
(13, 'Encyclopaedia Britannica', 'https://www.britannica.com/place/Antares-star'),
(14, 'National Aeronautics and Space Administration', 'https://nssdc.gsfc.nasa.gov/planetary/factsheet/sunfact.html'),
(15, 'Exploratorium', 'https://www.exploratorium.edu/eclipse/our-sun-is-a-star#:~:text=It%20is%20a%20G%2Dtype,holds%20the%20solar%20system%20together.'),
(16, 'National Aeronautics and Space Administration', 'https://eyes.nasa.gov/apps/exo/#/star/tau_Cet'),
(17, 'ZME Science', 'https://www.zmescience.com/feature-post/exploring-tau-ceti-alien-life/'),
(18, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/mercury/facts/#h-size-and-distance'),
(19, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/venus/venus-facts/'),
(20, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/earth/facts/'),
(21, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/mars/facts/'),
(22, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/jupiter/jupiter-facts/'),
(23, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/saturn/facts/'),
(24, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/uranus/facts/#h-size-and-distance'),
(25, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/neptune/neptune-facts/#h-size-and-distance'),
(26, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/exoplanet-catalog/proxima-centauri-b/'),
(27, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/exoplanet-catalog/gj-1289-b/'),
(28, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/exoplanet-catalog/tau-ceti-g/'),
(29, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/exoplanet-catalog/tau-ceti-e/'),
(30, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/moon/moon-phases/'),
(31, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/mars/moons/phobos/'),
(32, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/mars/moons/deimos/'),
(33, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/missions/hubble/hubble-finds-ozone-on-jupiters-moon-ganymede/'),
(34, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/jupiter/jupiter-moons/callisto/facts/#size-and-distance'),
(35, 'The Planetary Society', 'https://www.planetary.org/worlds/io'),
(36, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/jupiter/jupiter-moons/europa/europa-facts/#h-size-and-distance'),
(37, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/exoplanets/what-is-a-light-year/'),
(38, 'The Planetary Society', 'https://www.planetary.org/worlds/enceladus'),
(39, 'The Planetary Society', 'https://www.planetary.org/worlds/titan'),
(40, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/saturn/moons/dione/'),
(41, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/saturn/moons/rhea/'),
(42, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/saturn/moons/tethys/'),
(43, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/saturn/moons/mimas/'),
(44, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/uranus/moons/miranda/'),
(45, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/uranus/moons/umbriel/'),
(46, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/uranus/moons/titania/'),
(47, 'National Aeronautics and Space Administration', 'https://science.nasa.gov/neptune/moons/triton/'),
(48, ‘National Aeronautics and Space Administration’, ‘https://science.nasa.gov/mission/voyager/fact-sheet/’),
(49, ‘National Aeronautics and Space Administration’, ‘https://nssdc.gsfc.nasa.gov/planetary/factsheet/’),
(50, ‘National Aeronautics and Space Administration’, ‘https://nssdc.gsfc.nasa.gov/planetary/factsheet/joviansatfact.html’)
;

INSERT INTO source_galaxy(source_id, galaxy_id) VALUES
(1, 1), (2, 1), (3, 2), (4, 2), (2, 2), (5, 3), (6, 4), (2, 4), (7, 5), (8, 6);

INSERT INTO source_star(source_id, star_id) VALUES
(9, 1), (10, 1), (11, 2), (12, 3), (13, 4), (14, 5), (15, 5), (16, 6), (17, 6);

INSERT INTO source_planet(source_id, planet_id) VALUES
(18, 1), (49, 1), (19, 2), (49, 2), (20, 3), (49, 3), (21, 4), (49, 4), (22, 5),
(48, 5), (49, 5), (50, 5), (23, 6), (48, 6), (49, 6), (24, 7), (48, 7), (49,7),
(25, 8), (48, 8), (49, 8), (26, 9), (27, 10), (28, 11), (29, 12);

INSERT INTO source_moon(source_id, moon_id) VALUES
(30, 1), (49, 1), (31, 2), (32, 3), (33, 4), (48, 4), (50, 4), (34, 5), (48, 5),
(50, 5), (35, 6), (48, 6), (50, 6), (36, 7), (48, 7), (50, 7), (38, 8), (48, 8),
(39, 9), (48, 9), (40, 10), (48, 10), (41, 11), (48, 11), (42, 12), (43, 13),
(48, 13), (44, 14), (48, 14), (45, 15), (48, 15), (46, 16), (48, 16), (47, 17),
(48, 17), (48, 18), (50, 18), (50, 19), (50, 20), (48, 21), (50, 21), (48, 22),
(50, 22), (48, 23), (50, 23), (48, 24), (50, 24), (48, 25), (50, 25), (48, 26),
(50, 26), (48, 27), (48, 28), (48, 29), (48, 30), (48, 31), (48, 32), (48, 33),
(48, 34), (48, 35), (48, 36), (48, 37), (48, 38), (48, 39), (48, 40), (48, 41),
(48, 42), (48, 43), (48, 44), (48, 45), (48, 46), (48, 47), (48, 48), (48, 49),
(48, 50), (48, 51), (48, 52), (48, 53);
