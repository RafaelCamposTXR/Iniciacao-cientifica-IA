distanciaCamada = 4
distanciaNeuronio = 4


GeraRede(rede): 
 x,y,z = 0;
  for i in rede.tamanhoRede 
    GeraCamada(i)

# GeraRede(rede):
# Para i menor que número de camadas:
# Gera Camada(x)
# incrementa x


GeraCamada(i): #Extrair números de bias de uma camada específica
  GeraNeuroniosCamada(rede.i)
  if i > 0:
    ConectaLinhas(rede.i)

# Gera Camada(x):
# 	Gera neurônios da Camada(x)
# 	Se camada atual for maior que 0:
# 		Conecta linhas(x)


GeraNeuroniosCamada(camada):
  for j in camada:
    GeraNeuronio(x,y,z, Ativado)
    y += DistanciaNeuronio
    #salto em z ainda não implementado

# Gera neurônios da Camada(x):
# 	Para i menor que tamanho da camada
# 		Gera Neuronio(x,y,z)
# 		Salta y
# 		Salta z?


ConectaLinhas(camada):
  for i in camada:
    GeraConexão((x,y,z),(x0,y0,zo))
    InserePeso() #Extrair números de peso de uma camada em específico

# Conecta linhas(x)
# 	Para cada neurônio atual:
# 		Para i menor que o tamanho da camada[((x / distândiaCamada) - 1 )]:
# 		  Gera conexão((x,y,z),(x0,y0,z0))
# 		  Insere Peso( )
# 		  



