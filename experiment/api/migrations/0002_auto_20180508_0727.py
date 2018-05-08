# -*- coding: utf-8 -*-
# Generated by Django 1.11.6 on 2018-05-08 07:27
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='chatmessage',
            name='answer_to',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, to='api.ChatMessage'),
        ),
        migrations.AlterField(
            model_name='chatmessage',
            name='type',
            field=models.IntegerField(choices=[(1, 'question'), (2, 'answer')]),
        ),
    ]