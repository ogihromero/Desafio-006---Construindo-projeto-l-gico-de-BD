-- select da tabela cliente
select * from cliente;

-- filtro com WHERE em pedidos
select * from pedidos where id_cliente = 1;

-- insert em cliente
INSERT INTO cliente
(`idCliente`,
`Pnome`,
`NMeioInicial`,
`Sobrenome`,
`CPF`,
`Endereço`,
`DataDeNascimento`)
VALUES 
(1, 'João', 'AB', 'Silva', '12345678901', 'Rua 1', '1990-01-01');

-- expressão com atributo derivado
select * from cliente where idCliente = 1 and (Pnome + ' ' + Sobrenome) = 'João Silva';

-- orderby em cliente
select * from cliente order by DataDeNascimento;

-- having em cliente
select Pnome, Sobrenome, CPF from cliente group by DataDeNascimento having count(idCliente) > 10;

-- inner join clientes com pedidos
select * from cliente c inner join pedidos p on c.idCliente = p.Cliente_idCliente;