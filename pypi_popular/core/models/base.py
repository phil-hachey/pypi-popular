class Model(object):
    __schema__ = None

    def __init__(self, **kwargs):
        if self.__schema__ is None:
            raise Exception('Model.__schema__ unspecified')

        data = {}
        for key, value in kwargs.iteritems():
            model_attribute = __schema__.get(key)
            if model_attribute is None:
                raise Exception('Model attribute {} not found')
            data[key] = model_attribute(value)
