#### Baltic Sea AIS (Automatic Identification System) Data Pipeline ####
This is an experimental attempt to create an monthly batch ETL (Extract, Transform, Load) pipeline using Rust and Ballista for blazingly fast distributed data processing.

My goal is to break the mold and try something orders of magnitude more difficult than using Python and its Spark API.

Learning a compiled memory-safe, type-safe language like Rust is an investment.

#### Project Background and Data Dictionary ####

**Why AIS data?**
- I a have a vested interest in the phenomenon of maritime trade and travel. After an internship at Dun & Bradstreet, I became very interested in how data is collected and used as it relates to trade by sea, and the multitude of insights that can be derived about local and global economies.

**Why Baltic Sea data provided by the Danish Government?**
- Practically speaking, the data source in question is the only one I could find within the aforementioned topic with a comprehensive history and volume enough to do something interesting.
- Besides the previous point, I have always wanted to go to the Scandanavian countries, and I have always loved the stories of Vikings in the early medieval period. One can only imagine the millions of pairs of eyes that have witnessed the harsh and cold waters of the Baltic!

**Why Rust?**
- No offense to Python, but being that it is a dynamically-typed interpreted language, and the fact that I have been learning it since committing to learning software development last Spring, I feel that I have put myself at a conceptual disadvantage in comparison to my peers.
- As a major at UF who is only now starting my minor degree in Computer Science, things like memory allocation, data structures, and type safety are things I am just now learning.
- Rust is notoriously challenging to learn, but very rewarding. In learning and writing it, it has forced me to think much more about how a programming language interacts with the computer.
- Rust is rising in prevalence in the data world. As the demands of large scale data grow, using JVM-based systems like Spark and Flink carry an additional overhead. Rust compiles directly to byte-code, and there is a growing ecosystem for data-centric libraries like DataFusion, Ballista, and Arrow that expand Rust's capabilities for data processing.

**Data Dictionary**

-----------------------------------------------------------------------------------------------------------------
1.    **Timestamp:**                         Timestamp from the AIS basestation, format: 31/12/2015 23:59:59 
2.    **Type of mobile:**                    Describes what type of target this message is received from (class A AIS Vessel, Class B AIS vessel, etc)
3.    **MMSI:**                              MMSI number of vessel
4.    **Latitude:**                          Latitude of message report (e.g. 57,8794)
5.    **Longitude:**                         Longitude of message report (e.g. 17,9125)
6.    **Navigational status:**               Navigational status from AIS message if available, e.g.: 'Engaged in fishing', 'Under way using engine', mv.
7.    **ROT:**                               Rot of turn from AIS message if available
8.    **SOG:**                               Speed over ground from AIS message if available
9.    **COG:**                               Course over ground from AIS message if available
10.   **Heading:**                           Heading from AIS message if available
11.   **IMO:**                               IMO number of the vessel
12.   **Callsign:**                          Callsign of the vessel 
13.   **Name:**                              Name of the vessel
14.   **Ship type:**                         Describes the AIS ship type of this vessel 
15.   **Cargo type:**                        Type of cargo from the AIS message 
16.   **Width:**                             Width of the vessel
17.   **Length:**                            Lenght of the vessel 
18.   **Type of position fixing device:**    Type of positional fixing device from the AIS message 
19.   **Draught:**                           Draugth field from AIS message
20.   **Destination:**                       Destination from AIS message
21.   **ETA:**                               Estimated Time of Arrival, if available  
22.   **Data source type:**                  Data source type, e.g. AIS
23.   **Size A:**                            Length from GPS to the bow
24.   **Size B:**                            Length from GPS to the stern
25.   **Size C:**                            Length from GPS to starboard side
26.   **Size D:**                            Length from GPS to port side
