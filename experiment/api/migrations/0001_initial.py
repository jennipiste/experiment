# -*- coding: utf-8 -*-
# Generated by Django 1.11.6 on 2018-04-28 11:05
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='ChatDialog',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now=True)),
                ('name', models.CharField(max_length=400)),
            ],
        ),
        migrations.CreateModel(
            name='ChatMessage',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now=True)),
                ('message', models.TextField()),
                ('type', models.IntegerField(choices=[(1, 'incoming'), (2, 'outgoing')])),
                ('chat_dialog', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.ChatDialog')),
            ],
        ),
        migrations.CreateModel(
            name='Participant',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now=True)),
                ('name', models.CharField(max_length=400)),
            ],
        ),
        migrations.AddField(
            model_name='chatmessage',
            name='sender',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, to='api.Participant'),
        ),
        migrations.AddField(
            model_name='chatdialog',
            name='participant',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.Participant'),
        ),
    ]