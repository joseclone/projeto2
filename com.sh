rm ~/.bash_history
curl -sSL https://raw.githubusercontent.com/aandrew-me/tgpt/main/install | bash -s /usr/local/bin

#sudo rm $(which tgpt)
#u0_a299
# resultado = Produto.objects.filter(nome__contains='a')

read -p "Digite o nome do ambiente: " nome_ambiente
python -m venv $nome_ambiente

# ON LINUX
source $nome_ambiente/bin/activate

pip install --upgrade pip
pip install django

read -p "Digite o nome do seu Projeto: " nome_do_projeto
django-admin startproject $nome_do_projeto
cd $nome_do_projeto

read -p "Digite o nome da aplicacao: " aplicacao
django-admin startapp $aplicacao

sed -i "123a\CSRF_TRUSTED_ORIGINS = ['https://localhost:8000']" $nome_do_projeto/settings.py
sleep 10
sed -i 's/\(LANGUAGE_CODE = \).*$/\1"pt-Br"/' $nome_do_projeto/settings.py
sed -i 's/\(TIME_ZONE = \).*$/\1"America\/Recife"/' $nome_do_projeto/settings.py
sed -i "39a\    \'$aplicacao\'," $nome_do_projeto/settings.py

python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser

                    #VIEWS
# URLS PROJECT
read -p "Digite o nome da sua ROTA (views.py)" rota

sed -i "19a\from django.urls import include " $nome_do_projeto/urls.py
sed -i "22a\    path('$aplicacao/', include('$aplicacao.urls'))," $nome_do_projeto/urls.py

echo "from django.urls import path" > "$aplicacao/urls.py"
sed -i '1a\from . import views' $aplicacao/urls.py
sed -i "2a\ " $aplicacao/urls.py
sed -i "3a\ " $aplicacao/urls.py
sed -i "4a\urlpatterns = [" $aplicacao/urls.py
sed -i "5a\]" $aplicacao/urls.py
sed -i "5a\    path('$rota/', views.$rota, name='$rota')," $aplicacao/urls.py

# URLS APP
sed -i "1a\from django.http import HttpResponse " $aplicacao/views.py
sed -i "2a\from . import views " $aplicacao/views.py
sed -i "4a\ " $aplicacao/views.py
sed -i "5a\def $rota(request):" $aplicacao/views.py
sed -i "6a\     return HttpResponse('Chegou')" $aplicacao/views.py


read -p "Digite o nome do modelo (models.py)" model
# read -p "Digite o nome do atributo (models.py)" atrib
atrib='nome'
                    #MODELS
sed -i "3a\ " $aplicacao/models.py
sed -i "4a\class $model(models.Model):" $aplicacao/models.py
sed -i "5a\    $atrib = models.CharField(max_length=100)" $aplicacao/models.py

sed -i "6a\ " $aplicacao/models.py
sed -i "7a\    def __str__(self):" $aplicacao/models.py
sed -i "8a\        return self.$atrib" $aplicacao/models.py

sed -i "3a\ " $aplicacao/admin.py
sed -i "1a\from .models import *" $aplicacao/admin.py
sed -i "4a\admin.site.register($model)" $aplicacao/admin.py

python manage.py makemigrations
python manage.py migrate
python manage.py runserver



