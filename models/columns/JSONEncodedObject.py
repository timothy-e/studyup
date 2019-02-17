from sqlalchemy.types import TypeDecorator, VARCHAR
import json


class JSONEncodedObject(TypeDecorator):
    """
    Represents an immutable structure as a JSON encoded string.
    """

    impl = VARCHAR

    def process_bind_param(self, value, dialect):
        if value is not None:
            value = json.dumps(value)

        return value

    def process_result_value(self, value, dialect):
        if value is not None:
            value = json.loads(value)

        return value
