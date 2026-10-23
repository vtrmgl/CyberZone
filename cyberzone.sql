CREATE TABLE usuarios(
    id int auto_increment primary key,
    nome varchar(50) not null,
    email varchar(255) not null unique,
    cpf char(11) not null unique,
    telefone varchar(11) not null,
    data_de_nascimento date not null,
    data_cadastro datetime default current_timestamp not null
);
CREATE TABLE enderecos(
    id int auto_increment primary key,
    id_usuario int not null,
    cep char(8) not null,
    numero varchar(10) not null,
    complemento varchar(50),
    bairro varchar(100) not null,
    cidade varchar(50) not null,
    uf char(2) not null,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) on delete cascade on update cascade
);
CREATE TABLE categorias(
    id int auto_increment primary key,
    nome varchar(100) unique not null,
    descricao text not null
);
CREATE TABLE lojas(
    id int auto_increment primary key,
    id_usuario int not null,
    nome varchar(100) not null,
    email varchar(255) not null,
    cnpj char(14) unique not null,
    avaliacao decimal (3,2),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) on delete cascade on update cascade
);
CREATE TABLE produtos(
    id int auto_increment primary key,
    id_categoria int not null,
    id_loja int not null,
    nome varchar(100) not null,
    descricao text not null,
    estoque int not null default 1 check(estoque > 0),
    preco decimal(10, 2) not null,
    data_cadastro datetime default current_timestamp not null,
    marca varchar(100) not null,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id) on delete restrict on update cascade,
    FOREIGN KEY (id_loja) REFERENCES lojas(id) on delete cascade on update cascade
);
CREATE TABLE cupons(
    id int auto_increment primary key,
    codigo varchar(30) not null unique,
    tipo_desconto enum('Porcentagem', 'Fixo') not null default 'Porcentagem',
    valor_desconto decimal(10,2) not null check (valor_desconto > 0),
    valor_minimo_pedido decimal(10,2) default 0,
    data_validade datetime not null,
    limite_usos int default null,
    usos_atuais int default 0 check (usos_atuais >= 0),
    ativo boolean default TRUE,
    data_criacao datetime default current_timestamp not null
);
CREATE TABLE pedidos(
    id int auto_increment primary key,
    id_usuario int,
    id_endereco int,
    id_cupom int,
    status_pedido enum('Em processamento', 'Confirmado', 'Em rota', 'Em rota de entrega', 'Cancelado', 'Reembolsado') default 'Em processamento',
    valor_total decimal(10,2) default 0 check(valor_total > 0),
    data_tempo_pedido datetime default current_timestamp,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) on delete set null on update cascade,
    FOREIGN KEY (id_endereco) REFERENCES enderecos(id) on delete set null on update cascade,
    FOREIGN KEY (id_cupom) REFERENCES cupons(id) on delete set null on update cascade
);
CREATE TABLE itens_pedido(
    id int auto_increment primary key,
    id_pedido int not null,
    id_produto int,
    quantidade int default 1 check(quantidade > 0),
    preco_unitario decimal(10,2) default 0,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id) on delete cascade on update cascade,
    FOREIGN KEY (id_produto) REFERENCES produtos(id) on delete set null on update cascade
);
CREATE TABLE pagamentos(
    id int auto_increment primary key,
    id_pedido int not null,
    forma_pagamento enum('Pix', 'Crédito', 'Débito', 'Boleto') not null,
    status_pagamento enum('Pendente', 'Confirmado', 'Cancelado') not null,
    valor_total decimal(10,2) not null,
    data_pagamento datetime default current_timestamp,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id)
);

/*
Inserindo
*/

insert into usuarios(nome, email, cpf, telefone, data_de_nascimento)
values
    ('Vitor', 'vtr@gmail', '12345678910', '81912345678', '2002-06-30'),
    ('Bigas', 'gordo@gmail', '01987654321', '45987654321', '1994-07-17'),
    ('Tchuco', 'pcd@gmail', '01129384756', '85918273645', '1970-06-21'),
    ('Cauã', 'baum@gmail', '12233445566', '65748392016', '1962-06-17'),
    ('Japa', 'anime@gmail', '09897867565', '0123456789098', '1958-06-29');

insert into enderecos(id_usuario, cep, numero, complemento, bairro, cidade, uf)
values
    (1, '12345678', '203', 'Casa', 'Fundão', 'Recife', 'PE'),
    (1, '09812734', '20', 'Casa', 'Alto da Conquista', 'Olinda', 'PE'),
    (2, '45675432', '20092', 'Casa', 'Janga', 'Paulista', 'PE'),
    (3, '78656789', '3', null, 'Passarinho', 'Recife', 'PE'),
    (4, '20394830', '1000000000', null, 'Arruda', 'Recife', 'PE'),
    (5, '67384678', '1945', null, 'Casa Amarela', 'Recife', 'PE');

insert into categorias(nome, descricao) 
values
    ('Periféricos', 'Acessórios essenciais para navegação e produtividade, como mouses, teclados, mousepads e webcams.'),
    ('Hardware', 'Componentes internos para montagem e upgrade de computadores, como processadores, placas de vídeo e memórias RAM.'),
    ('Games e Consoles', 'Consoles de videogame, jogos físicos e digitais, além de controles e acessórios para diversas plataformas.'),
    ('Smartphones e Smartwatches', 'Dispositivos móveis inteligentes, relógios digitais, pulseiras de monitoramento e acessórios móveis.'),
    ('Áudio e Som', 'Equipamentos de reprodução sonora, incluindo fones de ouvido Bluetooth, headsets gamer, caixas de som e microfones.'),
    ('Monitores e Displays', 'Monitores de alta taxa de atualização, telas ultrawide, monitores 4K e suportes articulados.'),
    ('Redes e Conectividade', 'Roteadores Wi-Fi 6, adaptadores de rede, switches, repetidores de sinal e cabos de rede de alta velocidade.'),
    ('Cadeiras e Móveis Gamer', 'Cadeiras ergonômicas, mesas com ajuste de altura e suportes projetados para conforto e postura.'),
    ('Acessórios e Cabos', 'Cabos HDMI, adaptadores USB-C, carregadores rápidos, hubs USB e organizadores de fios.');

insert into lojas(id_usuario, nome, email, cnpj)
values
    (1, 'CyberTech Store', 'contato@cybertech.com', '12345678000101'),
    (2, 'Gamer Realm', 'vendas@gamerrealm.com', '23456789000102'),
    (3, 'ElectroWorld', 'atendimento@electroworld.com', '34567890000103'),
    (4, 'Byte & Cia', 'suporte@byteecia.com', '45678901000104');

insert into produtos(id_categoria, id_loja, nome, descricao, estoque, preco, marca)
values
    (1, 1, 'Mouse Gamer Sem Fio G305', 'Mouse óptico sem fio com sensor HERO de 12.000 DPI e 6 botões programáveis.', 25, 350.00, 'Logitech'),
    (1, 2, 'Teclado Mecânico Kumara K552', 'Teclado mecânico compacto RGB com switch azul de alta durabilidade.', 15, 280.00, 'Redragon'),
    (1, 1, 'Mousepad Extra Grande Speed', 'Mousepad em borracha antiderrapante com bordas costuradas de 900x400mm.', 40, 120.00, 'Razer'),
    (1, 4, 'Webcam Full HD C920s', 'Webcam 1080p com microfone estéreo integrado e proteção de privacidade.', 18, 320.00, 'Logitech'),
    (2, 3, 'Processador Core i7-13700K', 'Processador de 16 núcleos e 24 threads com clock de até 5.4GHz.', 10, 2400.00, 'Intel'),
    (2, 1, 'Placa de Vídeo RTX 4060 8GB', 'Placa de vídeo com arquitetura Ada Lovelace, Ray Tracing e DLSS 3.', 8, 2100.00, 'Gigabyte'),
    (2, 4, 'Memória RAM Vengeance 32GB DDR5', 'Kit de memória 32GB (2x16GB) 6000MHz otimizado para alta performance.', 20, 850.00, 'Corsair'),
    (2, 3, 'SSD M.2 NVMe NV2 1TB', 'SSD interno com velocidade de leitura de até 3500 MB/s.', 50, 420.00, 'Kingston'),
    (3, 2, 'Console PlayStation 5 Slim 1TB', 'Console PS5 Slim edição com leitor de discos e controle DualSense.', 12, 3799.00, 'Sony'),
    (3, 2, 'Controle Sem Fio Xbox Carbon Black', 'Controle ergonômico com gatilhos texturizados e conexão Bluetooth.', 22, 450.00, 'Microsoft'),
    (3, 3, 'Console Nintendo Switch OLED 64GB', 'Console portátil com tela OLED de 7 polegadas e Joy-Cons incluídos.', 15, 2199.00, 'Nintendo'),
    (4, 3, 'Smartphone Galaxy S23 FE 128GB', 'Smartphone com tela AMOLED 120Hz, câmara tripla e 8GB de RAM.', 14, 2699.00, 'Samsung'),
    (4, 1, 'Apple Watch SE GPS 40mm', 'Relógio inteligente com monitoramento de ritmo cardíaco e detecção de quedas.', 9, 2100.00, 'Apple'),
    (4, 4, 'Smartwatch Amazfit Bip 5', 'Relógio inteligente com tela de 1.91 polegadas e mais de 120 modos esportivos.', 30, 399.00, 'Amazfit'),
    (5, 2, 'Headset Gamer BlackShark V2 X', 'Headset com drivers de 50mm, som surround 7.1 e isolamento acústico.', 25, 310.00, 'Razer'),
    (5, 4, 'Fone de Ouvido Wave Flex Bluetooth', 'Fone TWS sem fio com resistência à água e bateria de até 32 horas.', 35, 249.00, 'JBL'),
    (5, 3, 'Caixa de Som Bluetooth Flip 6', 'Caixa de som portátil com proteção IP67 à prova d’água e 12h de reprodução.', 16, 650.00, 'JBL'),
    (6, 1, 'Monitor Gamer Hero 27" 165Hz', 'Monitor IPS Full HD com taxa de atualização de 165Hz e tempo de resposta de 1ms.', 14, 999.00, 'AOC'),
    (6, 3, 'Monitor Ultrawide 29" Full HD', 'Monitor IPS 21:9 com suporte HDR10 e recursos de divisão de tela.', 11, 1150.00, 'LG'),
    (7, 4, 'Roteador Wi-Fi 6 Archer AX12', 'Roteador Dual Band Wi-Fi 6 com tecnologia OFDMA e 4 antenas externas.', 22, 280.00, 'TP-Link'),
    (7, 4, 'Repetidor de Sinal Wi-Fi AC1200', 'Extensor de alcance Dual Band para eliminação de zonas mortas de sinal.', 45, 139.00, 'TP-Link'),
    (8, 2, 'Cadeira Gamer EC3 Ergonômica', 'Cadeira gamer com estofado em couro sintético e ajuste de inclinação.', 7, 1199.00, 'ThunderX3'),
    (8, 1, 'Mesa Gamer com Suporte para Fone', 'Mesa estruturada em aço com tampo reforçado e suporte para copos e fones.', 10, 480.00, 'Madesa'),
    (9, 4, 'Cabo HDMI 2.1 Ultra HD 8K 2m', 'Cabo HDMI de alta velocidade com suporte a resolução 8K e 120Hz em 4K.', 100, 45.00, 'PIX'),
    (9, 3, 'Hub USB-C 7 em 1 com HDMI 4K', 'Adaptador multiportas USB-C com entradas HDMI, USB 3.0 e leitores de cartão SD.', 28, 180.00, 'Baseus');

insert into cupons(codigo, tipo_desconto, valor_desconto, valor_minimo_pedido, data_validade, limite_usos)
values
    ('CYBER10', 'Porcentagem', 10.00, 100.00, '2026-12-31 23:59:59', 100),
    ('OFF50', 'Fixo', 50.00, 300.00, '2026-11-30 23:59:59', 50),
    ('BEMVINDO15', 'Porcentagem', 15.00, 0.00, '2027-01-01 00:00:00', NULL);

insert into pedidos(id_usuario, id_endereco, id_cupom, status_pedido, valor_total, data_tempo_pedido)
values
    (1, 1, null, 'Confirmado', 470.00, '2026-08-09 12:34:01'),
    (2, 3, null, 'Em rota de entrega', 4699.00, '2026-08-31 03:14:39'),
    (3, 4, 2, 'Confirmado', 4520.00, '2026-07-10 08:24:18'),
    (4, 5, 1, 'Em processamento', 339.00, '2026-09-30 17:38:51'),
    (1, 6, 3, 'Cancelado', 2699.00,'2026-08-18 10:09:12');

insert into itens_pedido(id_pedido, id_produto, quantidade, preco_unitario)
values
    (1, 1, 1, 350.00),
    (1, 3, 1, 120.00),
    (2, 9, 1, 3799.00),
    (2, 10, 2, 450.00),
    (3, 5, 1, 2400.00),
    (3, 7, 2, 850.00),
    (3, 8, 1, 420.00),
    (4, 16, 1, 249.00),
    (4, 24, 2, 45.00),
    (5, 12, 1, 2699.00);

insert into pagamentos(id_pedido, forma_pagamento, status_pagamento, valor_total)
values
    (1, 'Pix', 'Confirmado', 470.00),
    (2, 'Crédito', 'Confirmado', 4699.00),
    (3, 'Boleto', 'Confirmado', 4520.00),
    (4, 'Pix', 'Pendente', 339.00),
    (5, 'Débito', 'Cancelado', 2699.00);

/*
Consulta
*/

select
    count(*) as total_usuarios_maiores_16
from usuarios
where timestampdiff(year, data_de_nascimento, curdate()) > 16;

select
    pr.nome as produto,
    sum(ip.quantidade) as total_unidades_vendidas
from itens_pedido ip
inner join pedidos p on ip.id_pedido = p.id
inner join produtos pr on ip.id_produto = pr.id
where p.id_cupom is null 
  and MONTH(p.data_tempo_pedido) = 8
group by pr.id, pr.nome
order by total_unidades_vendidas desc;

select
    u.nome as cliente,
    COUNT(p.id_cupom) as quantidade_cupons_usados
from usuarios u
inner join pedidos p on u.id = p.id_usuario
where p.id_cupom is not null
group by u.id, u.nome
order by quantidade_cupons_usados desc
limit 1;

select
    u.id,
    u.nome as cliente_sem_compras,
    u.email
from usuarios u
left join pedidos p on u.id = p.id_usuario
where p.id is null;

select 
    u.id,
    u.nome as cliente,
    count(p.id) as total_pedidos,
    sum(p.valor_total) as total_gasto
from usuarios u
inner join pedidos p on u.id = p.id_usuario
where p.status_pedido != 'Cancelado'
group by u.id, u.nome
order by total_gasto desc
limit 1;