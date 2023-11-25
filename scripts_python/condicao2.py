password = '12345'

#dados de entrada
nome = input('Digite seu nome: ')
senha = input('Digite sua senha: ')

if password == senha and nome == "admin":
    print("Oi administrador, você tem acesso total ao sistema!")
elif password == senha:
    print("Bem vindo ao sistema",nome)
else:
    print("Ops... você errou a senha! Tente novamente")



