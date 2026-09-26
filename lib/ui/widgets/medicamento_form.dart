import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pastillero_inteligente/models/medicamento_model.dart';
import 'package:pastillero_inteligente/providers/paciente_provider.dart';
import 'package:pastillero_inteligente/theme/app_theme.dart';
import 'package:pastillero_inteligente/ui/widgets/compartimento_selector.dart';
import 'package:pastillero_inteligente/utils/validators.dart';

class MedicamentoForm extends StatefulWidget {
  final String pacienteId;

  const MedicamentoForm({super.key, required this.pacienteId});

  @override
  State<MedicamentoForm> createState() => _MedicamentoFormState();
}

class _MedicamentoFormState extends State<MedicamentoForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _dosisCtrl = TextEditingController();
  final _frecuenciaCtrl = TextEditingController();

  TimeOfDay? _horaSeleccionada;
  int? _compartimentoSeleccionado;

  Future<void> _seleccionarHora() async {
    final picker = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picker != null) {
      setState(() => _horaSeleccionada = picker);
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate() ||
        _horaSeleccionada == null ||
        _compartimentoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos, hora y compartimento'),
          backgroundColor: AppColors.alert,
        ),
      );
      return;
    }

    final horaStr =
        '${_horaSeleccionada!.hour.toString().padLeft(2, '0')}:${_horaSeleccionada!.minute.toString().padLeft(2, '0')}';

    final prov = context.read<PacienteProvider>();
    final ok = await prov.agregarMedicamento(widget.pacienteId, {
      'nombre': _nombreCtrl.text.trim(),
      'dosis': _dosisCtrl.text.trim(),
      'hora_toma': horaStr,
      'numero_compartimento': _compartimentoSeleccionado,
      'frecuencia': _frecuenciaCtrl.text.trim(),
    });

    if (!mounted) return;

    if (ok) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medicamento agregado'),
          backgroundColor: AppColors.primary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(prov.errorMessage ?? 'Error al agregar medicamento'),
          backgroundColor: AppColors.alert,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<PacienteProvider>();

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nuevo Medicamento',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre del medicamento',
                  prefixIcon: Icon(Icons.medication_outlined),
                ),
                validator: (v) => Validators.requerido(v, campo: 'Nombre'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dosisCtrl,
                decoration: const InputDecoration(
                  labelText: 'Dosis (ej. 1 pastilla, 500mg)',
                  prefixIcon: Icon(Icons.scale_outlined),
                ),
                validator: (v) => Validators.requerido(v, campo: 'Dosis'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _frecuenciaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Frecuencia (ej. Cada 8 horas)',
                  prefixIcon: Icon(Icons.repeat_outlined),
                ),
                validator: (v) => Validators.requerido(v, campo: 'Frecuencia'),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _seleccionarHora,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Hora de toma',
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  child: Text(
                    _horaSeleccionada == null
                        ? 'Seleccionar hora'
                        : _horaSeleccionada!.format(context),
                    style: TextStyle(
                      color: _horaSeleccionada == null
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CompartimentoSelector(
                seleccionado: _compartimentoSeleccionado,
                onChanged: (n) => setState(() => _compartimentoSeleccionado = n),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: prov.isLoading ? null : _guardar,
                child: prov.isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Guardar Medicamento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}