import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Actividad } from './actividad.entity';

@Entity('tipo_actividad')
export class TipoActividad {
  @PrimaryGeneratedColumn()
  id_tipo_actividad: number;

  @Column({ length: 80 })
  nombre_tipo: string;

  @Column({ length: 255, nullable: true })
  descripcion: string;

  @Column({ default: true })
  estado: boolean;

  @OneToMany(() => Actividad, (actividad) => actividad.tipo)
  actividades: Actividad[];
}
