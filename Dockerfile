FROM neo4j:3.0

VOLUME import
COPY ./local-package/* /tmp/
        docker run --publish=7474:7474 --publish=7687:7687 --volume=$HOME/neo4j/data:/data --name=neo4j --volume=$HOME/neo4j/logs:/logs neo4j:3.0
