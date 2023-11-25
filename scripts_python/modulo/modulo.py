import os

def create_dirs(dirpath):
    """esta é uma docstring"""
    if not os.path.exists(dirpath):
        os.makedirs(dirpath)
        
def funcao(arg):
    """esta é uma docstring"""
    print("Exemplo módulo")
    print(arg)