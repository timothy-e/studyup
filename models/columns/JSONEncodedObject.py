from sqlalchemy.types import TypeDecorator, VARCHAR
import json


class JSONEncodedObject(TypeDecorator):
    """
    Represents an immutable structure as a JSON encoded string.
    """

    impl = VARCHAR

    @classmethod
    def process_bind_param(value, dialect=None):
        if value is not None:
            value = json.dumps(value)

        return value

    @classmethod
    def process_result_value(value, dialect=None):
        if value is not None:
            value = json.loads(value)

        return value
