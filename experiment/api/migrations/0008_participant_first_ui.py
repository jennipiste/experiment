# -*- coding: utf-8 -*-
# Generated by Django 1.11.6 on 2018-06-01 07:01
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0007_participant_group'),
    ]

    operations = [
        migrations.AddField(
            model_name='participant',
            name='first_ui',
            field=models.IntegerField(choices=[(1, 'UI1'), (2, 'UI2')], null=True),
        ),
    ]
