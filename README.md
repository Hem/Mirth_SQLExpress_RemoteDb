# Mirth Setup using SQL Server Express edition

## Sql Server setup 
- Create a Mirth database
- Create a Mirth user account
- Set the mirth user account as the DB_OWNER for the mirth database 
- Set the default database for the Mirth User = Mirth Database !Important

    ### Update the connection information 
    - docker-compose.yml
    - mirth.properties.template [ May need this for SQL Server named instance configuration ]




## Mirth Set-up
- This is a docker container running openjdk:8
    - can change to java:7, java:8, openjdk:7 etc...
- Verify all ENV Variables are populated.
- Create the following directories
    - input
    - output
    - files
        - copy IVLMirthLibrary.js file
    - temp

    
    
    ## Shared volumes

    - ./input    => /home/files/input
    - ./output   => /home/files/output
    - ./scripts: => /home/files/scripts

    
    
    ## Missing [*.js files]

    - copy the IVLMirthLibrary.js file to /scripts


## wait-for-it
- We can wait for the database to be available if we execute


## SQL Scripts
~~~~ sql
WITH channels AS (
	SELECT c.NAME, CAST(c.CHANNEL AS XML) ChannelInfo
	FROM CHANNEL c
) 
SELECT DISTINCT '- "' + n.c.value('.', 'varchar(20)') + ':' + n.c.value('.', 'varchar(20)') + '" '
FROM channels c
	CROSS APPLY c.ChannelInfo.nodes('/channel/sourceConnector/properties/listenerConnectorProperties/port') N(c)
~~~~

~~~~ sql
WITH channels AS (
	SELECT c.NAME, CAST(c.CHANNEL AS XML) ChannelInfo
	FROM CHANNEL c
	WHERE c.NAME like '%trinity%'
) 
SELECT name, 
	e.c.value('(/channel/enabled)[1]', 'varchar(10)') [Enabled],
	e.c.value('(/channel/sourceConnector/properties/listenerConnectorProperties/port)[1]', 'int') [Port]
FROM channels c
	CROSS APPLY c.ChannelInfo.nodes('/channel') E(c)
~~~~