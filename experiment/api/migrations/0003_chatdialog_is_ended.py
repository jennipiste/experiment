# -*- coding: utf-8 -*-
# Generated by Django 1.11.6 on 2018-05-08 07:57
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_auto_20180508_0727'),
    ]

    operations = [
        migrations.AddField(
            model_name='chatdialog',
            name='is_ended',
            field=models.BooleanField(default=False),
        ),
    ]
