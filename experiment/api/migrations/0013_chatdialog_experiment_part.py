# -*- coding: utf-8 -*-
# Generated by Django 1.11.6 on 2018-06-09 08:48
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0012_participant_number'),
    ]

    operations = [
        migrations.AddField(
            model_name='chatdialog',
            name='experiment_part',
            field=models.IntegerField(choices=[(1, 'part1'), (2, 'part2'), (3, 'part3'), (4, 'part4')], null=True),
        ),
    ]
