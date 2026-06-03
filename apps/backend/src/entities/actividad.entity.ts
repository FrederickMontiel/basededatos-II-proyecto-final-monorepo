import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToOne } from 'typeorm';
import { Cliente } from './cliente.entity';
import { Contacto } from './contacto.entity';
import { Oportunidad } from './oportunidad.entity';
import { UsuarioComercial } from './usuario-comercial.entity';
import { TipoActividad } from './tipo-actividad.entity';
import { PrioridadActividad } from './prioridad-actividad.entity';
import { EstadoActividad } from './estado-actividad.entity';
import { FinalizacionActividad } from './finalizacion-actividad.entity';
import { DetalleReunion } from './detalle-reunion.entity';

@Entity('actividad')
export class Actividad {
  @PrimaryGeneratedColumn()
  id_actividad: number;

  @Column({ length: 30, unique: true })
  numero_actividad: string;

  @Column()
  id_cliente: number;

  @Column({ nullable: true })
  id_contacto: number;

  @Column({ nullable: true })
  id_oportunidad: number;

  @Column()
  id_usuario_responsable: number;

  @Column()
  id_tipo_actividad: number;

  @Column()
  id_prioridad_actividad: number;

  @Column({ nullable: true })
  id_estado_actividad: number;

  @Column({ nullable: true })
  id_finalizacion_actividad: number;

  @Column({ length: 150 })
  asunto: string;

  @Column({ type: 'date' })
  fecha_actividad: Date;

  @Column({ type: 'time', nullable: true })
  hora_inicio: string;

  @Column({ type: 'time', nullable: true })
  hora_final: string;

  @Column({ nullable: true })
  duracion_minutos: number;

  @Column({ length: 500, nullable: true })
  comentario: string;

  @Column({ type: 'datetime2', default: () => 'SYSDATETIME()' })
  fecha_creacion: Date;

  @Column({ type: 'datetime2', nullable: true })
  fecha_actualizacion: Date;

  @ManyToOne(() => Cliente, (cliente) => cliente.actividades)
  cliente: Cliente;

  @ManyToOne(() => Contacto, (contacto) => contacto.actividades, { nullable: true })
  contacto: Contacto;

  @ManyToOne(() => Oportunidad, (oportunidad) => oportunidad.actividades, { nullable: true })
  oportunidad: Oportunidad;

  @ManyToOne(() => UsuarioComercial, (usuario) => usuario.actividades)
  responsable: UsuarioComercial;

  @ManyToOne(() => TipoActividad, (tipo) => tipo.actividades)
  tipo: TipoActividad;

  @ManyToOne(() => PrioridadActividad, (prioridad) => prioridad.actividades)
  prioridad: PrioridadActividad;

  @ManyToOne(() => EstadoActividad, (estado) => estado.actividades, { nullable: true })
  estado_actividad: EstadoActividad;

  @ManyToOne(() => FinalizacionActividad, (finalizacion) => finalizacion.actividades, { nullable: true })
  finalizacion: FinalizacionActividad;

  @OneToOne(() => DetalleReunion, (detalle) => detalle.actividad, { nullable: true })
  detalle_reunion: DetalleReunion;
}
