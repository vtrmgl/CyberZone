/* Validação do formulário de login */

const formLogin = document.querySelector("#formulario-login");

if(formLogin){
    formLogin.addEventListener('submit', function(event){
        event.preventDefault();

        const email = document.querySelector('#email').value.trim();
        const senha = document.querySelector('#senha').value;

        if(email === '' || senha === ''){
            alert('Por favor, preencha todos os campos');
            return;
        }else if(senha.length < 8){
            alert('A senha deve ter pelo menos 8 caracteres');
            return;
        };

        alert('Login concluído com sucesso');

        window.location.href = 'inicio.html';
    });
};

/* Validação do formulário de cadastro */

const formCadastro = document.querySelector("#formulario-cadastro");

if(formCadastro){
    formCadastro.addEventListener('submit', function(event){
        event.preventDefault();

        const nome = document.querySelector('#nome').value.trim();
        const sobrenome = document.querySelector('#sobrenome').value.trim();
        let telefone = document.querySelector('#telefone').value;
        const dataDeNascimento = document.querySelector('#data-nascimento').value;
        let cpf = document.querySelector('#cpf').value;
        const email = document.querySelector('#email').value.trim();
        const senha = document.querySelector('#senha').value;
        const conSenha = document.querySelector('#conf-senha').value;

        telefone = telefone.replace(/\D/g, '');
        cpf = cpf.replace(/\D/g, '')
        const dataDeNascimentoComparacao = new Date(dataDeNascimento);
        const hoje = new Date();

        if(!nome || !sobrenome || !cpf || !email || !senha || !conSenha || !dataDeNascimento || !telefone){
            alert('Por favor, preencha todos os campos.');
            return;
        }else if(senha.length < 8 || conSenha.length < 8){
            alert('A senha deve ter pelo menos 8 caracteres.');
            return;
        }else if(senha !== conSenha){
            alert('As senhas são diferentes.');
            return;
        }else if(dataDeNascimentoComparacao >= hoje){
            alert('Insira uma data de nascimento válida.')
            return;
        }else if(telefone.length < 10 || telefone.length > 11){
            alert('Insira um número de telefone válido.')
            return;
        } else if(cpf.length !== 11){
            alert('Insira um cpf válido.');
            return;
        };

        alert('Cadastro feito com sucesso');

        window.location.href = 'login.html';
    });
};

/* Validação do formulário de Contato */

const formContato = document.querySelector("#form-contato");

if(formContato){
    formContato.addEventListener('submit', function(event){
        event.preventDefault();

        const nome = document.querySelector('#nome').value.trim();
        const email = document.querySelector('#email').value.trim();
        const assunto = document.querySelector('#assunto').value.trim();
        const mensagem = document.querySelector('#mensagem').value.trim();

        if(!nome || !email || !assunto || !mensagem){
            alert('Por favor, preencha todos os campos');
            return;
        }

        alert('Mensagem enviada com sucesso.');

        window.location.href = 'inicio.html';
    });
};