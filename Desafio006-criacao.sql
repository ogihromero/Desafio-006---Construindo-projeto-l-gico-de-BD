-- Criando tabela
create database ecommerce;
use ecommerce;

-- Criar tabela Cliente
CREATE TABLE IF NOT EXISTS Cliente (
  idCliente INT NOT NULL AUTO_INCREMENT,
  Pnome VARCHAR(15) NOT NULL,
  NMeioInicial VARCHAR(3) NULL,
  Sobrenome VARCHAR(20) NULL,
  CPF CHAR(11) NOT NULL,
  Endereço VARCHAR(45) NULL,
  DataDeNascimento DATE NOT NULL,
  PRIMARY KEY (idCliente),
  UNIQUE INDEX Identificação_UNIQUE (CPF ASC) VISIBLE);


-- -----------------------------------------------------
-- Table ecommerce.Pedido
-- -----------------------------------------------------
DROP TABLE IF EXISTS ecommerce.Pedido ;

CREATE TABLE IF NOT EXISTS ecommerce.Pedido (
  idPedido INT NOT NULL,
  Status ENUM('Em Andamento', 'Processando', 'Enviado', 'Entregue') NULL DEFAULT 'Processando',
  Descrição VARCHAR(45) NULL,
  DataPedido DATE NULL,
  Cliente_idCliente INT NOT NULL,
  PRIMARY KEY (idPedido, Cliente_idCliente),
  INDEX fk_Pedido_Cliente_idx (Cliente_idCliente ASC) VISIBLE,
  CONSTRAINT fk_Pedido_Cliente
    FOREIGN KEY (Cliente_idCliente)
    REFERENCES ecommerce.Cliente (idCliente)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ecommerce.Produto
-- -----------------------------------------------------
DROP TABLE IF EXISTS ecommerce.Produto ;

CREATE TABLE IF NOT EXISTS ecommerce.Produto (
  idProduto INT NOT NULL,
  Categoria VARCHAR(45) NULL,
  Descrição VARCHAR(45) NULL,
  Valor VARCHAR(45) NULL,
  PRIMARY KEY (idProduto))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ecommerce.Fornecedor
-- -----------------------------------------------------
DROP TABLE IF EXISTS ecommerce.Fornecedor ;

CREATE TABLE IF NOT EXISTS ecommerce.Fornecedor (
  idFornecedor INT NOT NULL,
  RazaoSocial VARCHAR(45) NULL,
  CNPJ VARCHAR(45) NULL,
  PRIMARY KEY (idFornecedor))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ecommerce.Disponibiliza
-- -----------------------------------------------------
DROP TABLE IF EXISTS ecommerce.Disponibiliza ;

CREATE TABLE IF NOT EXISTS ecommerce.Disponibiliza (
  Fornecedor_idFornecedor INT NOT NULL,
  Produto_idProduto INT NOT NULL,
  PRIMARY KEY (Fornecedor_idFornecedor, Produto_idProduto),
  INDEX fk_Fornecedor_has_Produto_Produto1_idx (Produto_idProduto ASC) VISIBLE,
  INDEX fk_Fornecedor_has_Produto_Fornecedor1_idx (Fornecedor_idFornecedor ASC) VISIBLE,
  CONSTRAINT fk_Fornecedor_has_Produto_Fornecedor1
    FOREIGN KEY (Fornecedor_idFornecedor)
    REFERENCES ecommerce.Fornecedor (idFornecedor)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Fornecedor_has_Produto_Produto1
    FOREIGN KEY (Produto_idProduto)
    REFERENCES ecommerce.Produto (idProduto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ecommerce.Estoque
-- -----------------------------------------------------
DROP TABLE IF EXISTS ecommerce.Estoque ;

CREATE TABLE IF NOT EXISTS ecommerce.Estoque (
  idEstoque INT NOT NULL,
  Local VARCHAR(45) NULL,
  PRIMARY KEY (idEstoque))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ecommerce.Possui
-- -----------------------------------------------------
DROP TABLE IF EXISTS ecommerce.Possui ;

CREATE TABLE IF NOT EXISTS ecommerce.Possui (
  Estoque_idEstoque INT NOT NULL,
  Produto_idProduto INT NOT NULL,
  Quantidade VARCHAR(45) NULL,
  PRIMARY KEY (Estoque_idEstoque, Produto_idProduto),
  INDEX fk_Estoque_has_Produto_Produto1_idx (Produto_idProduto ASC) VISIBLE,
  INDEX fk_Estoque_has_Produto_Estoque1_idx (Estoque_idEstoque ASC) VISIBLE,
  CONSTRAINT fk_Estoque_has_Produto_Estoque1
    FOREIGN KEY (Estoque_idEstoque)
    REFERENCES ecommerce.Estoque (idEstoque)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Estoque_has_Produto_Produto1
    FOREIGN KEY (Produto_idProduto)
    REFERENCES ecommerce.Produto (idProduto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ecommerce.Relação Produto/Pedido
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS RelaçaProdutoPedido (
  Produto_idProduto INT NOT NULL,
  Pedido_idPedido INT NOT NULL,
  Quantidade INT NOT NULL DEFAULT 0,
  Status ENUM('Disponível', 'Sem estoque') NULL DEFAULT 'disponível',
  PRIMARY KEY (Produto_idProduto, Pedido_idPedido),
  INDEX fk_Produto_has_Pedido_Pedido1_idx (Pedido_idPedido ASC) VISIBLE,
  INDEX fk_Produto_has_Pedido_Produto1_idx (Produto_idProduto ASC) VISIBLE,
  CONSTRAINT fk_Produto_has_Pedido_Produto1
    FOREIGN KEY (Produto_idProduto)
    REFERENCES ecommerce.Produto (idProduto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Produto_has_Pedido_Pedido1
    FOREIGN KEY (Pedido_idPedido)
    REFERENCES ecommerce.Pedido (idPedido)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ecommerce.Entrega
-- -----------------------------------------------------
DROP TABLE IF EXISTS ecommerce.Entrega ;

CREATE TABLE IF NOT EXISTS ecommerce.Entrega (
  idEntrega INT NOT NULL,
  CodigoRastreio VARCHAR(45) NULL,
  DataEnvio VARCHAR(45) NULL,
  DataEntrega VARCHAR(45) NULL,
  Status VARCHAR(45) NULL,
  Pedido_idPedido INT NOT NULL,
  PRIMARY KEY (idEntrega, Pedido_idPedido),
  INDEX fk_Entrega_Pedido1_idx (Pedido_idPedido ASC) VISIBLE,
  CONSTRAINT fk_Entrega_Pedido1
    FOREIGN KEY (Pedido_idPedido)
    REFERENCES ecommerce.Pedido (idPedido)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ecommerce.Terceiro - Vendedor
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS TerceiroVendedor (
  idTerceiroVendedor INT NOT NULL,
  RazaoSocial VARCHAR(45) NULL,
  Local VARCHAR(45) NOT NULL,
  NomeFantasia VARCHAR(45) NOT NULL,
  PRIMARY KEY (idTerceiroVendedor),
  UNIQUE INDEX RazaoSocial_UNIQUE (RazaoSocial ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ecommerce.Produtos/Vendedor
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS ProdutoVendedor (
  TerceiroVendedor_idTerceiroVendedor INT NOT NULL,
  Produto_idProduto INT NOT NULL,
  Quantidade INT NULL,
  PRIMARY KEY (TerceiroVendedor_idTerceiroVendedor, Produto_idProduto),
  INDEX fk_TerceiroVendedor_has_Produto_Produto1_idx (Produto_idProduto ASC) VISIBLE,
  INDEX fk_TerceiroVendedor_has_Produto_TerceiroVendedor1_idx (TerceiroVendedor_idTerceiroVendedor ASC) VISIBLE,
  CONSTRAINT fk_TerceiroVendedor_has_Produto_TerceiroVendedor1
    FOREIGN KEY (TerceiroVendedor_idTerceiroVendedor)
    REFERENCES ecommerce.TerceiroVendedor (idTerceiroVendedor)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_TerceiroVendedor_has_Produto_Produto1
    FOREIGN KEY (Produto_idProduto)
    REFERENCES ecommerce.Produto (idProduto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ecommerce.Pessoa Física
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS PessoaFisica (
  idPessoaFisica INT NOT NULL,
  CPF BIGINT NULL,
  Cliente_idCliente INT NOT NULL,
  PRIMARY KEY (idPessoaFisica, Cliente_idCliente),
  INDEX fk_PessoaFisica_Cliente1_idx (Cliente_idCliente ASC) VISIBLE,
  CONSTRAINT fk_PessoaFisica_Cliente1
    FOREIGN KEY (Cliente_idCliente)
    REFERENCES ecommerce.Cliente (idCliente)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ecommerce.Pessoa Jurídica
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS ecommerce.PessoaJuridica(
  idPessoaFisica INT NOT NULL,
  CNPJ BIGINT NULL,
  Cliente_idCliente INT NOT NULL,
  PRIMARY KEY (idPessoaFisica, Cliente_idCliente),
  INDEX fk_PessoaJuridica_Cliente1_idx (Cliente_idCliente ASC) VISIBLE,
  CONSTRAINT fk_PessoaJuridica_Cliente1
    FOREIGN KEY (Cliente_idCliente)
    REFERENCES ecommerce.Cliente (idCliente)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ecommerce.Pagamento
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS ecommerce.Pagamento (
  idPagamento INT NOT NULL,
  FormaPagamento VARCHAR(45) NULL,
  Pedido_idPedido INT NOT NULL,
  Pedido_Cliente_idCliente INT NOT NULL,
  PRIMARY KEY (idPagamento, Pedido_idPedido, Pedido_Cliente_idCliente),
  INDEX fk_Pagamento_Pedido1_idx (Pedido_idPedido ASC, Pedido_Cliente_idCliente ASC) VISIBLE,
  CONSTRAINT fk_Pagamento_Pedido1
    FOREIGN KEY (Pedido_idPedido , Pedido_Cliente_idCliente)
    REFERENCES ecommerce.Pedido (idPedido , Cliente_idCliente)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ecommerce.Boleto
-- -----------------------------------------------------
DROP TABLE IF EXISTS ecommerce.Boleto ;

CREATE TABLE IF NOT EXISTS ecommerce.Boleto (
  idBoleto INT NOT NULL,
  Valor DOUBLE NULL,
  DataPagamento DATE NULL,
  Pagamento_idPagamento INT NOT NULL,
  Pagamento_Pedido_idPedido INT NOT NULL,
  Pagamento_Pedido_Cliente_idCliente INT NOT NULL,
  PRIMARY KEY (idBoleto, Pagamento_idPagamento, Pagamento_Pedido_idPedido, Pagamento_Pedido_Cliente_idCliente),
  INDEX fk_Boleto_Pagamento1_idx (Pagamento_idPagamento ASC, Pagamento_Pedido_idPedido ASC, Pagamento_Pedido_Cliente_idCliente ASC) VISIBLE,
  CONSTRAINT fk_Boleto_Pagamento1
    FOREIGN KEY (Pagamento_idPagamento , Pagamento_Pedido_idPedido , Pagamento_Pedido_Cliente_idCliente)
    REFERENCES ecommerce.Pagamento (idPagamento , Pedido_idPedido , Pedido_Cliente_idCliente)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ecommerce.Cartão
-- -----------------------------------------------------
DROP TABLE IF EXISTS ecommerce.Cartão ;

CREATE TABLE IF NOT EXISTS ecommerce.Cartão (
  idCartão INT NOT NULL,
  Tipo VARCHAR(45) NULL,
  Parcelas INT NULL,
  Valor DOUBLE NULL,
  Número BIGINT NULL,
  DataVencimento DATE NULL,
  Pagamento_idPagamento INT NOT NULL,
  Pagamento_Pedido_idPedido INT NOT NULL,
  Pagamento_Pedido_Cliente_idCliente INT NOT NULL,
  PRIMARY KEY (idCartão, Pagamento_idPagamento, Pagamento_Pedido_idPedido, Pagamento_Pedido_Cliente_idCliente),
  INDEX fk_Cartão_Pagamento1_idx (Pagamento_idPagamento ASC, Pagamento_Pedido_idPedido ASC, Pagamento_Pedido_Cliente_idCliente ASC) VISIBLE,
  CONSTRAINT fk_Cartão_Pagamento1
    FOREIGN KEY (Pagamento_idPagamento , Pagamento_Pedido_idPedido , Pagamento_Pedido_Cliente_idCliente)
    REFERENCES ecommerce.Pagamento (idPagamento , Pedido_idPedido , Pedido_Cliente_idCliente)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


