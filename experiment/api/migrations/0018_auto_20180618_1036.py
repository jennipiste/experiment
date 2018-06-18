# -*- coding: utf-8 -*-
# Generated by Django 1.11.6 on 2018-06-18 10:36
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0017_auto_20180618_1008'),
    ]

    operations = [
        migrations.AddField(
            model_name='chatdialog',
            name='created_after_experiment_part_started',
            field=models.DecimalField(decimal_places=6, max_digits=12, null=True),
        ),
        migrations.AddField(
            model_name='chatmessage',
            name='created_after_experiment_part_started',
            field=models.DecimalField(decimal_places=6, max_digits=12, null=True),
        ),
    ]
